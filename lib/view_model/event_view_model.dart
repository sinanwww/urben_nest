import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:urben_nest/model/event_model.dart';

class EventViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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

  /// Create a new event for a community
  Future<bool> createEvent({
    required String communityId,
    required String title,
    required String description,
    required String venue,
    required DateTime date,
    required String time,
    required bool isPaid,
    String? paymentType,
    int? amount,
  }) async {
    // debugPrint('createEvent called for community: $communityId');
    _setLoading(true);
    _setError(null);

    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        debugPrint('User not logged in');
        _setError('User not logged in');
        return false;
      }

      // Fetch user's name
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

      // Generate event ID
      final String eventId = _db.ref().push().key!;

      // Prepare event data
      final Map<String, dynamic> eventData = {
        'communityId': communityId,
        'createdBy': currentUser.uid,
        'createdByName': userName,
        'title': title,
        'description': description,
        'venue': venue,
        'date': date.toIso8601String(),
        'time': time,
        'isPaid': isPaid,
        'paymentType': isPaid ? paymentType : null,
        'amount': isPaid && paymentType == 'fixed' ? amount : null,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      // Save to database
      // Save to database
      await _db
          .ref('events/$eventId')
          .set(eventData)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception('Database save timed out');
            },
          );

      return true;
    } catch (e, stackTrace) {
      debugPrint('Error in createEvent: $e');
      debugPrint('Stack trace: $stackTrace');
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Get all events for a specific community
  Stream<List<EventModel>> getCommunityEventsStream(String communityId) {
    return _db.ref('events').onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null || data is! Map) {
        return [];
      }

      final List<EventModel> events = [];
      data.forEach((key, value) {
        if (value is Map) {
          final eventModel = EventModel.fromMap(
            Map<String, dynamic>.from(value),
            key,
          );
          if (eventModel.communityId == communityId) {
            events.add(eventModel);
          }
        }
      });

      // Sort by date (newest first)
      events.sort((a, b) => b.date.compareTo(a.date));
      return events;
    });
  }

  /// Get all events across all communities
  Stream<List<EventModel>> getAllEventsStream() {
    return _db.ref('events').onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null || data is! Map) {
        return [];
      }

      final List<EventModel> events = [];
      data.forEach((key, value) {
        if (value is Map) {
          final eventModel = EventModel.fromMap(
            Map<String, dynamic>.from(value),
            key,
          );
          events.add(eventModel);
        }
      });

      // Sort by date (newest first)
      events.sort((a, b) => b.date.compareTo(a.date));
      return events;
    });
  }

  /// Delete an event
  Future<bool> deleteEvent(String eventId) async {
    _setLoading(true);
    _setError(null);

    try {
      await _db.ref('events/$eventId').remove();
      return true;
    } catch (e) {
      debugPrint('Error deleting event: $e');
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Toggle favorite status for an event
  Future<bool> toggleFavorite(String eventId) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        debugPrint('User not logged in');
        return false;
      }

      final favRef = _db.ref('users/${currentUser.uid}/favorites/$eventId');
      final snapshot = await favRef.get();

      if (snapshot.exists) {
        // Remove from favorites
        await favRef.remove();
      } else {
        // Add to favorites
        await favRef.set(true);
      }

      return true;
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      return false;
    }
  }

  /// Check if an event is favorited by current user
  Stream<bool> isEventFavorited(String eventId) {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value(false);
    }

    return _db
        .ref('users/${currentUser.uid}/favorites/$eventId')
        .onValue
        .map((event) => event.snapshot.exists);
  }

  /// Get user's favorite event IDs
  Stream<Set<String>> getUserFavoritesStream() {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value({});
    }

    return _db.ref('users/${currentUser.uid}/favorites').onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null || data is! Map) {
        return <String>{};
      }

      return data.keys.cast<String>().toSet();
    });
  }
}
