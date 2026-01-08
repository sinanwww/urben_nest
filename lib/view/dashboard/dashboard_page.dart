import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urben_nest/utls/app_theme.dart';
import 'package:urben_nest/utls/widgets/alert_box.dart';
import 'package:urben_nest/utls/widgets/float_button.dart';
import 'package:urben_nest/view/auth/login_page.dart';
import 'package:urben_nest/view/dashboard/create_cmty_page.dart';
import 'package:urben_nest/view_model/auth_view_model.dart';

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
            // Divider(thickness: 1, color: AppTheme.neutralGray),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) => Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRP3SSkfu1no5DYnnIV5jLJlI7fd7FtkgyEpg&s",
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),

                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Home",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "View your home details",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(thickness: 1, color: AppTheme.neutralGray),
                  ],
                ),
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
