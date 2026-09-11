import 'package:flutter/material.dart';
import 'package:movies_app/features/Home/data/models/movies.dart';

@immutable
abstract class MoviesState {}

class moviesInitial extends MoviesState {}

class moviesLoading extends MoviesState {}

class moviesLoaded extends MoviesState {
  final List<Movies> allMovies;
  final List<Movies> categoryMovies;
  final String category;

  moviesLoaded({
    required this.allMovies,
    required this.category,
    required this.categoryMovies,
  });
}

class moviesFailure extends MoviesState {
  String msg;
  moviesFailure({required this.msg});
}
