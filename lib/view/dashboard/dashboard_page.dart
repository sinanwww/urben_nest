import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urben_nest/utls/app_theme.dart';
import 'package:urben_nest/utls/widgets/alert_box.dart';
import 'package:urben_nest/utls/widgets/dash_tail.dart';
import 'package:urben_nest/utls/widgets/float_button.dart';
import 'package:urben_nest/view/auth/login_page.dart';
import 'package:urben_nest/view/bottem_nav/nav_controller.dart';
import 'package:urben_nest/view/dashboard/create_cmty_page.dart';
import 'package:urben_nest/view_model/auth_view_model.dart';
import 'package:urben_nest/view_model/community_view_model.dart';
import 'package:urben_nest/model/community_model.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(30.0),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.20,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: AppTheme.neutralGray,
                    ),
                  ),

                  const SizedBox(width: 16),

                  StreamBuilder<DatabaseEvent>(
                    stream: context.read<AuthViewModel>().userStream,
                    builder: (context, snapshot) {
                      dynamic data;
                      if (snapshot.hasData &&
                          snapshot.data!.snapshot.value != null) {
                        data = snapshot.data!.snapshot.value;
                      }

                      final name =
                          (data is Map ? data['name'] : null) ?? 'User';
                      final phone =
                          (data is Map ? data['phone'] : null) ?? 'No Phone';

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome, $name",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            phone,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      );
                    },
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertBox(
                            title: "Logout",
                            message: "Are you sure you want to logout?",
                            onConfirm: () {
                              context.read<AuthViewModel>().signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                                (route) => false,
                              );
                            },
                            icon: Icons.logout,
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.logout, size: 30, color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: context
                    .read<CommunityViewModel>()
                    .userCommunitiesWithRoleStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final communitiesWithRole = snapshot.data ?? [];
                  if (communitiesWithRole.isEmpty) {
                    return const Center(child: Text('No communities yet.'));
                  }

                  // Separate communities by role
                  final adminCommunities = communitiesWithRole.where((item) {
                    final role = item['role'] as String;
                    return role == 'creator' || role == 'admin';
                  }).toList();

                  final memberCommunities = communitiesWithRole.where((item) {
                    final role = item['role'] as String;
                    return role == 'member';
                  }).toList();

                  return ListView(
                    children: [
                      // Admin Communities Section
                      if (adminCommunities.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.admin_panel_settings,
                                color: AppTheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Admin Communities',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...adminCommunities.map((item) {
                          final community = item['community'] as CommunityModel;
                          final role = item['role'] as String;

                          return DashTail(
                            image: community.communityImageUrl.isNotEmpty
                                ? community.communityImageUrl
                                : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRP3SSkfu1no5DYnnIV5jLJlI7fd7FtkgyEpg&s",
                            title: community.communityName,
                            subtitle: community.propertyType,
                            role: role,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NavController(communityId: community.id),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ],

                      // Member Communities Section
                      if (memberCommunities.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.people,
                                color: Colors.grey[700],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Member Communities',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...memberCommunities.map((item) {
                          final community = item['community'] as CommunityModel;
                          final role = item['role'] as String;

                          return DashTail(
                            image: community.communityImageUrl.isNotEmpty
                                ? community.communityImageUrl
                                : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRP3SSkfu1no5DYnnIV5jLJlI7fd7FtkgyEpg&s",
                            title: community.communityName,
                            subtitle: community.propertyType,
                            role: role,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NavController(communityId: community.id),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateCmtyPage()),
          );
        },
      ),
    );
  }
}
