import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urben_nest/view_model/member_view_model.dart';

class MemberDetailViewModel extends ChangeNotifier {
  String _currentUserRole = 'member';
  String _selectedRole = 'member';

  String get currentUserRole => _currentUserRole;
  String get selectedRole => _selectedRole;

  bool get canManageMembers {
    return _currentUserRole == 'creator' || _currentUserRole == 'admin';
  }

  void setSelectedRole(String role) {
    _selectedRole = role;
    notifyListeners();
  }

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
}
