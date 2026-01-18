import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urben_nest/view_model/member_view_model.dart';

class DrawerViewModel extends ChangeNotifier {
  String _currentUserRole = 'member';

  String get currentUserRole => _currentUserRole;

  bool get canLeave => _currentUserRole != 'creator';

  Future<void> loadCurrentUserRole(
    String? communityId,
    MemberViewModel memberViewModel,
  ) async {
    if (communityId == null) return;

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
