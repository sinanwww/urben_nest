import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urben_nest/utls/app_theme.dart';
import 'package:urben_nest/utls/widgets/costom_appbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:urben_nest/view_model/member_view_model.dart';

class MemberDetailPage extends StatelessWidget {
  final String communityId;
  final String memberId;

  const MemberDetailPage({
    super.key,
    required this.communityId,
    required this.memberId,
  });

  Stream<Map<String, dynamic>?> _getMemberStream() {
    return FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          'https://urben-nest-46415-default-rtdb.asia-southeast1.firebasedatabase.app',
    ).ref('communities/$communityId/members/$memberId').onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null || data is! Map) {
        return null;
      }
      return Map<String, dynamic>.from(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Member Detail'),
      body: StreamBuilder<Map<String, dynamic>?>(
        stream: _getMemberStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final memberData = snapshot.data;
          if (memberData == null) {
            return const Center(child: Text('Member not found'));
          }

          final name = memberData['name'] ?? 'Unknown';
          final email = memberData['email'] ?? 'N/A';
          final phone = memberData['phone'] ?? 'N/A';
          final flatNumber = memberData['flatNumber'] ?? 'N/A';
          final role = memberData['role'] ?? 'member';
          final addedAt = memberData['addedAt'] ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppTheme.primary,
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'M',
                    style: const TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    role.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                _buildInfoCard(
                  icon: Icons.apartment,
                  label: 'Flat Number',
                  value: flatNumber,
                ),
                const SizedBox(height: 16),
                _buildInfoCard(icon: Icons.phone, label: 'Phone', value: phone),
                const SizedBox(height: 16),
                _buildInfoCard(icon: Icons.email, label: 'Email', value: email),
                if (addedAt.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    icon: Icons.calendar_today,
                    label: 'Member Since',
                    value: _formatDate(addedAt),
                  ),
                ],
                const SizedBox(height: 32),
                // Edit and Remove buttons
                Column(
                  children: [
                    // Change Role button (only for non-creators)
                    if (role != 'creator')
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showChangeRoleDialog(
                              context,
                              name,
                              role,
                              flatNumber,
                            );
                          },
                          icon: const Icon(Icons.admin_panel_settings),
                          label: const Text('Change Role'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    if (role != 'creator') const SizedBox(height: 12),
                    // Edit and Remove buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showEditDialog(context, flatNumber);
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showDeleteConfirmation(context, name);
                            },
                            icon: const Icon(Icons.delete),
                            label: const Text('Remove'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return isoDate;
    }
  }

  void _showEditDialog(BuildContext context, String currentFlatNumber) {
    final TextEditingController flatNumberController = TextEditingController(
      text: currentFlatNumber == 'N/A' ? '' : currentFlatNumber,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Member'),
        content: TextField(
          controller: flatNumberController,
          decoration: const InputDecoration(
            labelText: 'Flat Number',
            hintText: 'Enter flat number',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final newFlatNumber = flatNumberController.text.trim();
              Navigator.pop(context);

              final memberViewModel = context.read<MemberViewModel>();
              final success = await memberViewModel.updateMemberInCommunity(
                communityId: communityId,
                userId: memberId,
                flatNumber: newFlatNumber,
              );

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Member updated successfully'
                          : 'Failed to update member',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String memberName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text(
          'Are you sure you want to remove $memberName from this community?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              final memberViewModel = context.read<MemberViewModel>();
              final success = await memberViewModel.removeMemberFromCommunity(
                communityId: communityId,
                userId: memberId,
              );

              if (context.mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Member removed successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Go back to members list
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to remove member'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showChangeRoleDialog(
    BuildContext context,
    String memberName,
    String currentRole,
    String currentFlatNumber,
  ) {
    showDialog(
      context: context,
      builder: (context) => ChangeNotifierProvider(
        create: (_) => _RoleSelectionNotifier(currentRole),
        child: Consumer<_RoleSelectionNotifier>(
          builder: (context, notifier, _) => AlertDialog(
            title: const Text('Change Member Role'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Change role for $memberName'),
                const SizedBox(height: 16),
                RadioListTile<String>(
                  title: const Text('Member'),
                  subtitle: const Text('Can view community information'),
                  value: 'member',
                  groupValue: notifier.selectedRole,
                  onChanged: (value) => notifier.setRole(value!),
                ),
                RadioListTile<String>(
                  title: const Text('Admin'),
                  subtitle: const Text('Can add, edit, and remove members'),
                  value: 'admin',
                  groupValue: notifier.selectedRole,
                  onChanged: (value) => notifier.setRole(value!),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  final selectedRole = notifier.selectedRole;
                  Navigator.pop(context);

                  final memberViewModel = context.read<MemberViewModel>();
                  final success = await memberViewModel.updateMemberInCommunity(
                    communityId: communityId,
                    userId: memberId,
                    flatNumber: currentFlatNumber == 'N/A'
                        ? ''
                        : currentFlatNumber,
                    role: selectedRole,
                  );

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? 'Role updated to ${selectedRole.toUpperCase()}'
                              : 'Failed to update role',
                        ),
                        backgroundColor: success ? Colors.green : Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Simple notifier for role selection in dialog
class _RoleSelectionNotifier extends ChangeNotifier {
  String _selectedRole;

  _RoleSelectionNotifier(this._selectedRole);

  String get selectedRole => _selectedRole;

  void setRole(String role) {
    _selectedRole = role;
    notifyListeners();
  }
}
