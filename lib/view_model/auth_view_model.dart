import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
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

  Stream<DatabaseEvent> get userStream {
    return _db.ref('users/${_auth.currentUser?.uid}').onValue;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      try {
        await _db.ref('users/${cred.user!.uid}').set({
          'name': name,
          'email': email,
          'phone': phone,
          'createdAt': DateTime.now().toIso8601String(),
        });
      } catch (dbError) {
        // If database write fails, delete the auth user to keep consistency
        await cred.user!.delete();
        _setError(
          'Database error: ${dbError.toString()}. Please check your Realtime Database rules.',
        );
        return false;
      }

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _setError('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _setError('The account already exists for that email.');
      } else {
        _setError(e.message ?? 'An unknown error occurred.');
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    _setLoading(true);
    _setError(null);

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _setError('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _setError('Wrong password provided for that user.');
      } else {
        _setError(e.message ?? 'An unknown error occurred.');
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<bool> resetPassword({required String email}) async {
    _setLoading(true);
    _setError(null);

    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _setError('No user found for that email.');
      } else if (e.code == 'invalid-email') {
        _setError('Invalid email address.');
      } else {
        _setError(e.message ?? 'An unknown error occurred.');
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
