import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urben_nest/utls/app_theme.dart';
import 'package:urben_nest/view/bottem_nav/add_event_page.dart';
import 'package:urben_nest/view/chat/chat_page.dart';
import 'package:urben_nest/view/concern/concern_page.dart';
import 'package:urben_nest/view/home/home_page.dart';
import 'package:urben_nest/view/members/members_page.dart';
import 'package:urben_nest/view_model/member_view_model.dart';
import 'package:urben_nest/view_model/navigation_view_model.dart';

class NavController extends StatelessWidget {
  final String communityId;

  const NavController({super.key, required this.communityId});

  @override
  Widget build(BuildContext context) {
    // Initialize pages
    final pages = [
      HomePage(communityId: communityId),
      ConcernPage(),
      MembersPage(communityId: communityId),
      const ChatPage(),
    ];

    return ChangeNotifierProvider(
      create: (context) {
        final navViewModel = NavigationViewModel();
        // Load user role
        final memberViewModel = context.read<MemberViewModel>();
        navViewModel.loadCurrentUserRole(communityId, memberViewModel);
        return navViewModel;
      },
      child: Consumer<NavigationViewModel>(
        builder: (context, navViewModel, child) {
          return Scaffold(
            body: Stack(
              children: [
                pages[navViewModel.selectedIndex],

                // Glassmorphic Action Menu Overlay
                if (navViewModel.showActionMenu)
                  GestureDetector(
                    onTap: () => navViewModel.closeActionMenu(),
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                  ),

                // Action Menu
                if (navViewModel.showActionMenu)
                  Positioned(
                    bottom: 70,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Column(
                                children: [
                                  _buildActionMenuItem(
                                    context: context,
                                    navViewModel: navViewModel,
                                    label: 'Add Event',
                                    onTap: () {
                                      navViewModel.closeActionMenu();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddEventPage(
                                            communityId: communityId,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  _buildDivider(),
                                  _buildActionMenuItem(
                                    context: context,
                                    navViewModel: navViewModel,
                                    label: 'Add Asset',
                                    onTap: () {
                                      navViewModel.closeActionMenu();
                                      // TODO: Navigate to Add Asset page
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Add Asset - Coming Soon',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  _buildDivider(),
                                  _buildActionMenuItem(
                                    context: context,
                                    navViewModel: navViewModel,
                                    label: 'Add Poll',
                                    onTap: () {
                                      navViewModel.closeActionMenu();
                                      // TODO: Navigate to Add Poll page
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Add Poll - Coming Soon',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: _buildActionMenuItem(
                              context: context,
                              navViewModel: navViewModel,
                              label: 'Cancel',
                              isCancel: true,
                              onTap: () => navViewModel.closeActionMenu(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: navViewModel.selectedIndex,
              onTap: (index) => navViewModel.setSelectedIndex(index),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppTheme.primary,
              unselectedItemColor: AppTheme.neutralGray,
              showUnselectedLabels: true,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.feedback_outlined),
                  activeIcon: Icon(Icons.feedback),
                  label: 'Concern',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people_outline),
                  activeIcon: Icon(Icons.people),
                  label: 'Members',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_bubble_outline),
                  activeIcon: Icon(Icons.chat_bubble),
                  label: 'Chat',
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: navViewModel.canAddMembers
                ? SizedBox(
                    height: 45,
                    width: 45,
                    child: FloatingActionButton(
                      shape: const CircleBorder(),
                      backgroundColor: AppTheme.primary,
                      onPressed: () => navViewModel.toggleActionMenu(),
                      child: Icon(
                        navViewModel.showActionMenu ? Icons.close : Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }

  Widget _buildActionMenuItem({
    required BuildContext context,
    required NavigationViewModel navViewModel,
    required String label,
    required VoidCallback onTap,
    bool isCancel = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isCancel ? FontWeight.w600 : FontWeight.w500,
                color: isCancel ? Colors.red : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 0.5, color: Colors.grey);
  }
}
