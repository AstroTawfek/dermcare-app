import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current logged-in user
  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;
  String get displayName => _auth.currentUser?.displayName ?? 'User';
  String get email => _auth.currentUser?.email ?? '';

  // ── Sign Up ─────────────────────────────────────────────────────────
  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      // Save user profile to Firestore
      await _firestore.collection('users').doc(cred.user!.uid).set({
        'name': name.trim(),
        'email': email.trim(),
        'uid': cred.user!.uid,
        'phone': '',
        'profileImage': '',
        'createdAt': FieldValue.serverTimestamp(),
      });
      // Update Firebase Auth display name
      await cred.user!.updateDisplayName(name.trim());
      notifyListeners();
      return null; // null = success
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Sign up failed';
    }
  }

  // ── Login ───────────────────────────────────────────────────────────
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      notifyListeners();
      return null; // null = success
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Login failed';
    }
  }

  // ── Logout ──────────────────────────────────────────────────────────
  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }
}
