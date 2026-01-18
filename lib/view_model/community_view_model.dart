import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:urben_nest/model/community_model.dart';

class CommunityViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://urben-nest-46415-default-rtdb.asia-southeast1.firebasedatabase.app',
  );
  // final FirebaseStorage _storage = FirebaseStorage.instance;

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

  // Helper to upload either XFile or PlatformFile
  // Future<String> _uploadFile(dynamic file, String folder) async {
  //   try {
  //     debugPrint('Starting upload for $folder...');
  //     String fileName;
  //     Uint8List fileBytes;

  //     if (file is XFile) {
  //       fileName = file.name;
  //       fileBytes = await file.readAsBytes();
  //     } else if (file is PlatformFile) {
  //       fileName = file.name;
  //       if (file.bytes != null) {
  //         fileBytes = file.bytes!;
  //       } else if (file.path != null) {
  //         fileBytes = await File(file.path!).readAsBytes();
  //       } else {
  //         throw Exception('Unsupported file format or empty file');
  //       }
  //     } else {
  //       throw Exception('Unsupported file type');
  //     }

  //     final String uniqueName =
  //         '${DateTime.now().millisecondsSinceEpoch}_$fileName';
  //     final Reference ref = _storage.ref().child('$folder/$uniqueName');

  //     debugPrint('Putting data to $folder/$uniqueName');
  //     // Use putData for cross-platform compatibility (works on Web & Mobile)
  //     final UploadTask uploadTask = ref.putData(
  //       fileBytes,
  //       SettableMetadata(contentType: 'application/octet-stream'),
  //     );

  //     // Add a snapshot listener for progress debugging
  //     uploadTask.snapshotEvents.listen(
  //       (TaskSnapshot snapshot) {
  //         debugPrint(
  //           'Upload progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %',
  //         );
  //       },
  //       onError: (e) {
  //         debugPrint('Upload error event: $e');
  //       },
  //     );

  //     final TaskSnapshot snapshot = await uploadTask
  //         .whenComplete(() {})
  //         .timeout(
  //           const Duration(seconds: 45),
  //           onTimeout: () {
  //             debugPrint('Upload timed out for $folder');
  //             uploadTask.cancel();
  //             throw TimeoutException('File upload timed out');
  //           },
  //         );

  //     debugPrint('Upload completed for $folder. Getting download URL...');
  //     final url = await snapshot.ref.getDownloadURL().timeout(
  //       const Duration(seconds: 15),
  //       onTimeout: () {
  //         throw TimeoutException('Getting download URL timed out');
  //       },
  //     );
  //     debugPrint('Got URL: $url');
  //     return url;
  //   } catch (e) {
  //     debugPrint('Error in _uploadFile: $e');
  //     throw Exception('Failed to upload file: $e');
  //   }
  // }

  Future<bool> createCommunityRequest({
    required String communityName,
    required String phone,
    required Map<String, dynamic> location,
    required String propertyType,
    XFile? communityImage,
    PlatformFile? documentProof,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        _setError('User not logged in');
        return false;
      }

      // 1. Upload images
      // debugPrint('Uploading community image...');
      // final String communityImageUrl = await _uploadFile(
      //   communityImage,
      //   'community_images',
      // );
      // debugPrint('Community image uploaded: $communityImageUrl');
      String communityImageUrl = "";

      // debugPrint('Uploading document proof...');
      // final String documentProofUrl = await _uploadFile(
      //   documentProof,
      //   'document_proofs',
      // );
      // debugPrint('Document proof uploaded: $documentProofUrl');
      String documentProofUrl = "";

      // 2. Prepare data
      final String requestId = _db.ref().push().key!;
      final Map<String, dynamic> requestData = {
        'userId': currentUser.uid,
        'userName': currentUser.displayName ?? 'Unknown User',
        'userEmail': currentUser.email,
        'communityName': communityName,
        'phone': phone,
        'location': location,
        'propertyType': propertyType,
        'communityImageUrl': communityImageUrl,
        'documentProofUrl': documentProofUrl,
        'status': 'pending', // Requires admin approval
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      // 3. Submit to Database
      // Same to database...
      await _db
          .ref('community_requests/$requestId')
          .set(requestData)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw TimeoutException('Database save timed out');
            },
          );

      // 4. Add creator as the first member

      // Fetch user's actual name from users collection
      String userName = 'Unknown User';
      try {
        final userSnapshot = await _db.ref('users/${currentUser.uid}').get();
        if (userSnapshot.exists && userSnapshot.value is Map) {
          final userData = Map<String, dynamic>.from(userSnapshot.value as Map);
          userName =
              userData['name'] ?? currentUser.displayName ?? 'Unknown User';
        }
      } catch (e) {
        debugPrint('Error fetching user name: $e');
        userName = currentUser.displayName ?? 'Unknown User';
      }

      final creatorMemberData = {
        'name': userName,
        'email': currentUser.email ?? '',
        'phone': phone,
        'flatNumber': '', // Creator can update this later
        'role': 'creator',
        'addedAt': DateTime.now().toIso8601String(),
      };

      await _db
          .ref('communities/$requestId/members/${currentUser.uid}')
          .set(creatorMemberData)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw TimeoutException('Adding creator as member timed out');
            },
          );

      return true;
    } catch (e, stackTrace) {
      debugPrint('Error in createCommunityRequest: $e');
      debugPrint('Stack trace: $stackTrace');
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Stream<List<CommunityModel>> get approvedCommunitiesStream {
    return _db.ref('community_requests').onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null || data is! Map) {
        return [];
      }

      final List<CommunityModel> communities = [];
      data.forEach((key, value) {
        if (value is Map) {
          final community = CommunityModel.fromMap(
            Map<String, dynamic>.from(value),
            key,
          );
          if (community.status == 'approved') {
            communities.add(community);
          }
        }
      });
      return communities;
    });
  }

  // Stream to get communities created by the current user
  Stream<List<CommunityModel>> get userCreatedCommunitiesStream {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }

    return _db.ref('community_requests').onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null || data is! Map) {
        return [];
      }

      final List<CommunityModel> communities = [];
      data.forEach((key, value) {
        if (value is Map) {
          final community = CommunityModel.fromMap(
            Map<String, dynamic>.from(value),
            key,
          );

          // Filter by current user ID and approved status
          if (community.status == 'approved' &&
              community.userId == currentUser.uid) {
            communities.add(community);
          }
        }
      });
      return communities;
    });
  }

  // Stream to get ALL communities where user is a member (including created ones)
  // Returns a list of maps with community data and user's role
  Stream<List<Map<String, dynamic>>> get userCommunitiesWithRoleStream {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }

    return _db.ref('community_requests').onValue.asyncMap((event) async {
      final data = event.snapshot.value;
      if (data == null || data is! Map) {
        return [];
      }

      final List<Map<String, dynamic>> communitiesWithRole = [];

      for (var entry in data.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value is Map) {
          final community = CommunityModel.fromMap(
            Map<String, dynamic>.from(value),
            key,
          );

          // Only include approved communities
          if (community.status != 'approved') {
            continue;
          }

          // Check if user is a member of this community
          final memberSnapshot = await _db
              .ref('communities/$key/members/${currentUser.uid}')
              .get();

          if (memberSnapshot.exists && memberSnapshot.value is Map) {
            final memberData = Map<String, dynamic>.from(
              memberSnapshot.value as Map,
            );
            final role = memberData['role'] ?? 'member';

            communitiesWithRole.add({'community': community, 'role': role});
          }
        }
      }
      return communitiesWithRole;
    });
  }
}
