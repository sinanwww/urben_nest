import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:urben_nest/model/user_model.dart';

class MemberViewModel extends ChangeNotifier {
  final FirebaseDatabase _db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://urben-nest-46415-default-rtdb.asia-southeast1.firebasedatabase.app',
  );

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  // Get all registered users from Firebase
  Stream<List<UserModel>> getAllUsersStream() {
    return _db.ref('users').onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null || data is! Map) {
        return [];
      }

      final List<UserModel> users = [];
      data.forEach((key, value) {
        if (value is Map) {
          final user = UserModel.fromJson(
            Map<String, dynamic>.from(value),
            key,
          );
          users.add(user);
        }
      });
      return users;
    });
  }

  // Get members of a specific community
  Stream<List<Map<String, dynamic>>> getCommunityMembersStream(
    String communityId,
  ) {
    return _db.ref('communities/$communityId/members').onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null || data is! Map) {
        return [];
      }

      final List<Map<String, dynamic>> members = [];
      data.forEach((key, value) {
        if (value is Map) {
          final member = Map<String, dynamic>.from(value);
          member['userId'] = key; // Add the user ID to the member data
          members.add(member);
        }
      });
      return members;
    });
  }

  // Get list of user IDs who are already members of a community
  Future<Set<String>> getCommunityMemberIds(String communityId) async {
    try {
      final snapshot = await _db.ref('communities/$communityId/members').get();
      if (snapshot.value == null || snapshot.value is! Map) {
        return {};
      }

      final data = snapshot.value as Map;
      return data.keys.cast<String>().toSet();
    } catch (e) {
      debugPrint('Error getting community member IDs: $e');
      return {};
    }
  }

  // Add a member to a community
  Future<bool> addMemberToCommunity({
    required String communityId,
    required String userId,
    required String name,
    required String email,
    required String phone,
    required String flatNumber,
    String role = 'member',
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final memberData = {
        'name': name,
        'email': email,
        'phone': phone,
        'flatNumber': flatNumber,
        'role': role,
        'addedAt': DateTime.now().toIso8601String(),
      };

      await _db.ref('communities/$communityId/members/$userId').set(memberData);

      return true;
    } catch (e) {
      debugPrint('❌ Error adding member: $e');
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update a member's information in a community
  Future<bool> updateMemberInCommunity({
    required String communityId,
    required String userId,
    required String flatNumber,
    String? role,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final updates = <String, dynamic>{'flatNumber': flatNumber};

      if (role != null) {
        updates['role'] = role;
      }

      await _db.ref('communities/$communityId/members/$userId').update(updates);

      return true;
    } catch (e) {
      debugPrint('❌ Error updating member: $e');
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Remove a member from a community
  Future<bool> removeMemberFromCommunity({
    required String communityId,
    required String userId,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      await _db.ref('communities/$communityId/members/$userId').remove();

      return true;
    } catch (e) {
      debugPrint('❌ Error removing member: $e');
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Filter users based on search query
  List<UserModel> filterUsers(List<UserModel> users, String query) {
    if (query.isEmpty) return users;

    final lowerQuery = query.toLowerCase();
    return users.where((user) {
      return user.name.toLowerCase().contains(lowerQuery) ||
          user.email.toLowerCase().contains(lowerQuery) ||
          user.phone.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Filter members based on search query
  List<Map<String, dynamic>> filterMembers(
    List<Map<String, dynamic>> members,
    String query,
  ) {
    if (query.isEmpty) return members;

    final lowerQuery = query.toLowerCase();
    return members.where((member) {
      final name = (member['name'] ?? '').toString().toLowerCase();
      final email = (member['email'] ?? '').toString().toLowerCase();
      final phone = (member['phone'] ?? '').toString().toLowerCase();
      final flatNumber = (member['flatNumber'] ?? '').toString().toLowerCase();

      return name.contains(lowerQuery) ||
          email.contains(lowerQuery) ||
          phone.contains(lowerQuery) ||
          flatNumber.contains(lowerQuery);
    }).toList();
  }
}
