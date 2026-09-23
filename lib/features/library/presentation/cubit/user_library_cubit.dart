import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/library/data/models/saved_movie.dart';
import 'package:movies_app/features/library/data/repository/user_library_repository.dart';

import 'user_library_state.dart';

class UserLibraryCubit extends Cubit<UserLibraryState> {
  final UserLibraryRepository repository;

  UserLibraryCubit({required this.repository})
      : super(const UserLibraryInitial());

  List<SavedMovie> _favorites = [];
  List<SavedMovie> _history = [];

  String? _loadedUid;

  List<SavedMovie> get favorites => List.unmodifiable(_favorites);

  List<SavedMovie> get history => List.unmodifiable(_history);

  bool isFavorite(int movieId) => _favorites.any((movie) => movie.id == movieId);

  void _emitLoaded() {
    emit(UserLibraryLoaded(
      favorites: List.of(_favorites),
      history: List.of(_history),
    ));
  }

  Future<void> load() async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      _loadedUid = null;
      _favorites = [];
      _history = [];
      _emitLoaded();
      return;
    }

    if (_loadedUid != uid) {
      _favorites = [];
      _history = [];
    }

    emit(const UserLibraryLoading());
    try {
      final favorites = await repository.getFavorites();
      final history = await repository.getHistory();
      _loadedUid = uid;
      _favorites = favorites;
      _history = history;
      _emitLoaded();
    } catch (_) {
      emit(UserLibraryFailure(message: 'Failed to load your movies'));
    }
  }

  Future<void> toggleFavorite(SavedMovie movie) async {
    final bool wasFavorite = isFavorite(movie.id);
    if (wasFavorite) {
      _favorites.removeWhere((item) => item.id == movie.id);
    } else {
      _favorites.insert(0, movie);
    }
    _emitLoaded();

    try {
      if (wasFavorite) {
        await repository.removeFavorite(movie.id);
      } else {
        await repository.addFavorite(movie);
      }
    } catch (_) {
      if (wasFavorite) {
        _favorites.insert(0, movie);
      } else {
        _favorites.removeWhere((item) => item.id == movie.id);
      }
      _emitLoaded();
    }
  }

  Future<void> addToHistory(SavedMovie movie) async {
    _history.removeWhere((item) => item.id == movie.id);
    _history.insert(0, movie);
    _emitLoaded();

    try {
      await repository.addToHistory(movie);
    } catch (_) {
      // Persistence is best-effort; history is already applied locally.
    }
  }
}