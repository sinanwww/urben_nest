import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urben_nest/view_model/member_view_model.dart';

class MemberPageViewModel extends ChangeNotifier {
  String _searchQuery = '';
  String _currentUserRole = 'member';

  String get searchQuery => _searchQuery;
  String get currentUserRole => _currentUserRole;

  bool get canAddMembers {
    return _currentUserRole == 'creator' || _currentUserRole == 'admin';
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  /// Load current user's role in the community
  Future<void> loadCurrentUserRole(
    String communityId,
    MemberViewModel memberViewModel,
  ) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final membersStream = memberViewModel.getCommunityMembersStream(
      communityId,
    );

    membersStream.listen((members) {
      final currentUserMember = members.firstWhere(
        (member) => member['userId'] == currentUser.uid,
        orElse: () => {},
      );

      if (currentUserMember.isNotEmpty) {
        _currentUserRole = currentUserMember['role'] ?? 'member';
        notifyListeners();
      }
    });
  }

  /// Sort members with current user first
  List<Map<String, dynamic>> sortMembersWithCurrentUserFirst(
    List<Map<String, dynamic>> members,
  ) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return members;

    final sortedMembers = List<Map<String, dynamic>>.from(members);
    sortedMembers.sort((a, b) {
      final aIsCurrentUser = a['userId'] == currentUser.uid;
      final bIsCurrentUser = b['userId'] == currentUser.uid;
      if (aIsCurrentUser && !bIsCurrentUser) return -1;
      if (!aIsCurrentUser && bIsCurrentUser) return 1;
      return 0;
    });

    return sortedMembers;
  }
}
