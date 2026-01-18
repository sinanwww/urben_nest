import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urben_nest/view_model/member_view_model.dart';

class NavigationViewModel extends ChangeNotifier {
  int _selectedIndex = 0;
  bool _showActionMenu = false;
  String _currentUserRole = 'member';

  int get selectedIndex => _selectedIndex;
  bool get showActionMenu => _showActionMenu;
  String get currentUserRole => _currentUserRole;

  bool get canAddMembers {
    return _currentUserRole == 'creator' || _currentUserRole == 'admin';
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void toggleActionMenu() {
    _showActionMenu = !_showActionMenu;
    notifyListeners();
  }

  void closeActionMenu() {
    _showActionMenu = false;
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
