import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movies_app/features/library/data/models/saved_movie.dart';

class UserLibraryRepository {
  final FirebaseFirestore firestore;

  UserLibraryRepository({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _favoritesCollection(String uid) =>
      firestore.collection('profiles').doc(uid).collection('favorites');

  CollectionReference<Map<String, dynamic>> _historyCollection(String uid) =>
      firestore.collection('profiles').doc(uid).collection('history');

  Future<List<SavedMovie>> getFavorites() async {
    final String? uid = _uid;
    if (uid == null) return const [];
    final QuerySnapshot<Map<String, dynamic>> query =
        await _favoritesCollection(uid)
            .orderBy('addedAt', descending: true)
            .get();
    return query.docs.map((doc) => SavedMovie.fromJson(doc.data())).toList();
  }

  Future<void> addFavorite(SavedMovie movie) async {
    final String? uid = _uid;
    if (uid == null) return;
    await _favoritesCollection(uid).doc('${movie.id}').set({
      ...movie.toJson(),
      'addedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> removeFavorite(int movieId) async {
    final String? uid = _uid;
    if (uid == null) return;
    await _favoritesCollection(uid).doc('$movieId').delete();
  }

  Future<List<SavedMovie>> getHistory() async {
    final String? uid = _uid;
    if (uid == null) return const [];
    final QuerySnapshot<Map<String, dynamic>> query =
        await _historyCollection(uid)
            .orderBy('watchedAt', descending: true)
            .get();
    return query.docs.map((doc) => SavedMovie.fromJson(doc.data())).toList();
  }

  Future<void> addToHistory(SavedMovie movie) async {
    final String? uid = _uid;
    if (uid == null) return;
    await _historyCollection(uid).doc('${movie.id}').set({
      ...movie.toJson(),
      'watchedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }
}