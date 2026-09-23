import 'package:flutter/material.dart';
import 'package:movies_app/features/Home/data/models/movies.dart';

@immutable
abstract class BrowseState {}

class browseInitial extends BrowseState {}

class browseLoading extends BrowseState {}

class browseLoaded extends BrowseState {
  final List<Movies> movies;
  final String genre;

  browseLoaded({required this.movies, required this.genre});
}

class browseFailure extends BrowseState {
  final String msg;

  browseFailure({required this.msg});
}