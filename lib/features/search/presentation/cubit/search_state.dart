import 'package:flutter/material.dart';
import 'package:movies_app/features/Home/data/models/movies.dart';

@immutable
abstract class SearchState {}

class searchInitial extends SearchState {}

class searchLoading extends SearchState {}

class searchLoaded extends SearchState {
  final List<Movies> movies;
  final String query;

  searchLoaded({required this.movies, required this.query});
}

class searchEmpty extends SearchState {}

class searchFailure extends SearchState {
  final String msg;

  searchFailure({required this.msg});
}