import 'package:movies_app/features/library/data/models/saved_movie.dart';

abstract class UserLibraryState {
  const UserLibraryState();
}

class UserLibraryInitial extends UserLibraryState {
  const UserLibraryInitial();
}

class UserLibraryLoading extends UserLibraryState {
  const UserLibraryLoading();
}

class UserLibraryLoaded extends UserLibraryState {
  final List<SavedMovie> favorites;
  final List<SavedMovie> history;

  const UserLibraryLoaded({
    required this.favorites,
    required this.history,
  });
}

class UserLibraryFailure extends UserLibraryState {
  final String message;

  const UserLibraryFailure({required this.message});
}