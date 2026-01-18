import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urben_nest/model/user_model.dart';
import 'package:urben_nest/utls/app_theme.dart';
import 'package:urben_nest/utls/widgets/costom_appbar.dart';
import 'package:urben_nest/utls/widgets/input_field.dart';
import 'package:urben_nest/view_model/add_members_view_model.dart';
import 'package:urben_nest/view_model/member_view_model.dart';

class AddMembersPage extends StatelessWidget {
  final String communityId;

  const AddMembersPage({super.key, required this.communityId});

  void _showAddMemberDialog(BuildContext context, UserModel user) {
    final TextEditingController flatNumberController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Add ${user.name}'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enter details for ${user.name}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: flatNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Flat/Unit Number',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., A-101',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter flat number';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final memberViewModel = context.read<MemberViewModel>();
                  final addMembersViewModel = context
                      .read<AddMembersViewModel>();

                  final success = await memberViewModel.addMemberToCommunity(
                    communityId: communityId,
                    userId: user.uid,
                    name: user.name,
                    email: user.email,
                    phone: user.phone,
                    flatNumber: flatNumberController.text.trim(),
                  );

                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${user.name} added successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      // Refresh existing members
                      addMembersViewModel.refreshMembers(
                        communityId,
                        memberViewModel,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            memberViewModel.errorMessage ??
                                'Failed to add member',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return ChangeNotifierProvider(
      create: (context) {
        final viewModel = AddMembersViewModel();
        final memberViewModel = context.read<MemberViewModel>();
        viewModel.loadExistingMembers(communityId, memberViewModel);
        return viewModel;
      },
      child: Consumer<AddMembersViewModel>(
        builder: (context, addMembersViewModel, child) {
          // Update search query when controller changes
          searchController.addListener(() {
            addMembersViewModel.updateSearchQuery(searchController.text);
          });

          return Scaffold(
            appBar: CustomAppbar(title: 'Add Members'),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SerchField(controller: searchController),
                ),
                Expanded(
                  child: Consumer<MemberViewModel>(
                    builder: (context, memberViewModel, child) {
                      return StreamBuilder<List<UserModel>>(
                        stream: memberViewModel.getAllUsersStream(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }

                          final allUsers = snapshot.data ?? [];

                          // Filter out existing members
                          final availableUsers = allUsers
                              .where(
                                (user) => !addMembersViewModel.existingMemberIds
                                    .contains(user.uid),
                              )
                              .toList();

                          // Apply search filter
                          final filteredUsers = memberViewModel.filterUsers(
                            availableUsers,
                            addMembersViewModel.searchQuery,
                          );

                          if (filteredUsers.isEmpty) {
                            return Center(
                              child: Text(
                                addMembersViewModel.searchQuery.isEmpty
                                    ? 'No users available to add'
                                    : 'No users found matching "${addMembersViewModel.searchQuery}"',
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: filteredUsers.length,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemBuilder: (context, index) {
                              final user = filteredUsers[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: AppTheme.primary,
                                    child: Text(
                                      user.name.isNotEmpty
                                          ? user.name[0].toUpperCase()
                                          : 'U',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    user.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(user.email),
                                      Text(user.phone),
                                    ],
                                  ),
                                  trailing: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primary,
                                    ),
                                    onPressed: () =>
                                        _showAddMemberDialog(context, user),
                                    child: const Text(
                                      'Add',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
