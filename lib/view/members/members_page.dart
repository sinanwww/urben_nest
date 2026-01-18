import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urben_nest/utls/app_theme.dart';
import 'package:urben_nest/utls/widgets/input_field.dart';
import 'package:urben_nest/view/members/add_members_page.dart';
import 'package:urben_nest/view/members/member_detail_page.dart';
import 'package:urben_nest/view_model/member_view_model.dart';
import 'package:urben_nest/view_model/member_page_view_model.dart';

class MembersPage extends StatelessWidget {
  final String communityId;

  const MembersPage({super.key, required this.communityId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final viewModel = MemberPageViewModel();
        final memberViewModel = context.read<MemberViewModel>();
        viewModel.loadCurrentUserRole(communityId, memberViewModel);
        return viewModel;
      },
      child: Consumer<MemberPageViewModel>(
        builder: (context, pageViewModel, child) {
          return Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SerchField(
                    onChanged: (value) =>
                        pageViewModel.updateSearchQuery(value),
                  ),
                ),
                Expanded(
                  child: Consumer<MemberViewModel>(
                    builder: (context, memberViewModel, child) {
                      return StreamBuilder<List<Map<String, dynamic>>>(
                        stream: memberViewModel.getCommunityMembersStream(
                          communityId,
                        ),
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

                          final allMembers = snapshot.data ?? [];

                          // Apply search filter
                          final filteredMembers = memberViewModel.filterMembers(
                            allMembers,
                            pageViewModel.searchQuery,
                          );

                          // Sort members: current user first
                          final sortedMembers = pageViewModel
                              .sortMembersWithCurrentUserFirst(filteredMembers);

                          if (sortedMembers.isEmpty) {
                            return Center(
                              child: Text(
                                pageViewModel.searchQuery.isEmpty
                                    ? 'No members yet.\nTap + to add members.'
                                    : 'No members found matching "${pageViewModel.searchQuery}"',
                                textAlign: TextAlign.center,
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: sortedMembers.length,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemBuilder: (context, index) {
                              final member = sortedMembers[index];
                              final userId = member['userId'] ?? '';
                              final name = member['name'] ?? 'Unknown';
                              final phone = member['phone'] ?? '';
                              final role = member['role'] ?? 'member';
                              final currentUser =
                                  FirebaseAuth.instance.currentUser;
                              final isCurrentUser =
                                  currentUser != null &&
                                  userId == currentUser.uid;

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
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MemberDetailPage(
                                          communityId: communityId,
                                          memberId: userId,
                                        ),
                                      ),
                                    );
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: AppTheme.primary,
                                    child: Text(
                                      name.isNotEmpty
                                          ? name[0].toUpperCase()
                                          : 'M',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (isCurrentUser) ...[
                                              const SizedBox(width: 6),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.green
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  border: Border.all(
                                                    color: Colors.green,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: const Text(
                                                  'YOU',
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      if (role != 'member')
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                (role == 'creator' ||
                                                    role == 'admin')
                                                ? AppTheme.primary.withOpacity(
                                                    0.1,
                                                  )
                                                : Colors.grey.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            border: Border.all(
                                              color:
                                                  (role == 'creator' ||
                                                      role == 'admin')
                                                  ? AppTheme.primary
                                                  : Colors.grey,
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            role.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              color:
                                                  (role == 'creator' ||
                                                      role == 'admin')
                                                  ? AppTheme.primary
                                                  : Colors.grey[700],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  subtitle: phone.isNotEmpty
                                      ? Text(phone)
                                      : null,
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
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
            floatingActionButton: pageViewModel.canAddMembers
                ? FloatingActionButton(
                    backgroundColor: AppTheme.primary,
                    shape: const CircleBorder(),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              AddMembersPage(communityId: communityId),
                        ),
                      );
                    },
                    child: const Icon(Icons.add, color: Colors.white),
                  )
                : null,
          );
        },
      ),
    );
  }
}
