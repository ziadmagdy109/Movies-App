import '../../model/movies_details.dart';

abstract class MoviesDetailsState {}
class MoviesInital extends  MoviesDetailsState {}
class MoviesDetailsLoading extends MoviesDetailsState {}
class MoviesDetailsLoaded extends MoviesDetailsState {
  final MoviesDetails moviesDetails;
  MoviesDetailsLoaded({required this.moviesDetails});
}
class MoviesDetailsFailure extends MoviesDetailsState {
  final String msg;
  MoviesDetailsFailure({required this.msg});
}