import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_profile.dart';

class ProfileRepository {
  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  Future<UserProfile?> getProfile() async {
    final String? uid = _uid;
    if (uid == null) return null;

    final DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(uid)
        .get()
        .timeout(const Duration(seconds: 10));

    if (!document.exists) return null;
    return UserProfile.fromJson(
      document.data() as Map<String, dynamic>? ?? const {},
    );
  }

  Future<void> saveProfile(UserProfile profile) async {
    final String? uid = _uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection('profiles')
        .doc(uid)
        .set(profile.toJson())
        .timeout(const Duration(seconds: 10));
  }
}