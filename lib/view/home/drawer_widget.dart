import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urben_nest/utls/app_theme.dart';
import 'package:urben_nest/view_model/drawer_view_model.dart';
import 'package:urben_nest/view_model/member_view_model.dart';

class DrawerWidget extends StatelessWidget {
  final String? communityId;

  const DrawerWidget({super.key, this.communityId});

  void _showLeaveCommunityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Community'),
        content: const Text(
          'Are you sure you want to leave this community? You will need to be re-added by an admin to rejoin.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              final currentUser = FirebaseAuth.instance.currentUser;
              if (currentUser == null || communityId == null) return;

              final memberViewModel = context.read<MemberViewModel>();
              final success = await memberViewModel.removeMemberFromCommunity(
                communityId: communityId!,
                userId: currentUser.uid,
              );

              if (context.mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You have left the community'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).popUntil((route) => route.isFirst);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to leave community'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final viewModel = DrawerViewModel();
        final memberViewModel = context.read<MemberViewModel>();
        viewModel.loadCurrentUserRole(communityId, memberViewModel);
        return viewModel;
      },
      child: Consumer<DrawerViewModel>(
        builder: (context, drawerViewModel, child) {
          return Drawer(
            shape: const BeveledRectangleBorder(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR5K2n2CnpEtKE9VUKktLIvubATuBz30xUIeg&s",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: const Text('John Doe'),
                      subtitle: const Text('7732211442'),
                      trailing: IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () {},
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ExpansionTile(
                    title: const Text('Emergency'),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return ListTile(
                            trailing: const Icon(Icons.call),
                            title: Row(
                              children: [
                                Text(
                                  'fire   :',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text("5544112222"),
                              ],
                            ),
                            onTap: () {},
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text('Add Emergency'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _settings(
                    context,
                    title: 'Transactions',
                    icon: Icons.account_balance_wallet_outlined,
                    onTap: () {},
                  ),
                  _settings(
                    context,
                    title: 'Reports',
                    icon: Icons.receipt_long_outlined,
                    onTap: () {},
                  ),
                  _settings(
                    context,
                    title: 'Assets',
                    icon: Icons.apartment_rounded,
                    onTap: () {},
                  ),
                  _settings(
                    context,
                    title: 'Visitors',
                    icon: Icons.group_outlined,
                    onTap: () {},
                  ),
                  _settings(
                    context,
                    title: 'Guidelines',
                    icon: Icons.receipt_outlined,
                    onTap: () {},
                  ),
                  // Only show Leave Community for non-creators
                  if (communityId != null && drawerViewModel.canLeave)
                    _settings(
                      context,
                      title: 'Leave Community',
                      icon: Icons.exit_to_app,
                      onTap: () => _showLeaveCommunityDialog(context),
                    ),
                  _settings(
                    context,
                    title: 'Logout',
                    icon: Icons.logout,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _settings(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 12),
            Text(title),
          ],
        ),
      ),
    );
  }
}
