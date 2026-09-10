import 'package:flutter/material.dart';
import 'package:movies_app/features/Home/data/models/movies.dart';

@immutable
abstract class MoviesState {}

class moviesInitial extends MoviesState {}

class moviesLoading extends MoviesState {}

class moviesLoaded extends MoviesState {
  final List<Movies> allMovies;

  moviesLoaded({required this.allMovies});
}

class moviesFailure extends MoviesState {}
