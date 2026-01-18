import 'package:flutter/material.dart';
import 'package:urben_nest/view_model/member_view_model.dart';

class AddMembersViewModel extends ChangeNotifier {
  String _searchQuery = '';
  Set<String> _existingMemberIds = {};

  String get searchQuery => _searchQuery;
  Set<String> get existingMemberIds => _existingMemberIds;

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadExistingMembers(
    String communityId,
    MemberViewModel memberViewModel,
  ) async {
    final memberIds = await memberViewModel.getCommunityMemberIds(communityId);
    _existingMemberIds = memberIds;
    notifyListeners();
  }

  void refreshMembers(String communityId, MemberViewModel memberViewModel) {
    loadExistingMembers(communityId, memberViewModel);
  }
}
