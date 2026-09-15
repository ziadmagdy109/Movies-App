import 'package:bloc/bloc.dart';
import 'package:movies_app/features/Home/data/repository/movies_repository.dart';
import 'package:movies_app/features/MovieDetails/repo/movie_details_repo.dart';
import 'movies_details_state.dart';

class MoviesDetailsCubit extends Cubit<MoviesDetailsState> {
  final MovieDetailsRepo movieDetailsRepository;

  MoviesDetailsCubit({required this.movieDetailsRepository}) : super(MoviesInital());

  Future<void> getMovieDetails(int movieId) async {
    emit(MoviesDetailsLoading());
    try {
      final movieDetailsList = await movieDetailsRepository.getMovieDetails(movieId);
      emit(MoviesDetailsLoaded(moviesDetails: movieDetailsList));
    } catch (e) {
      emit(MoviesDetailsFailure(msg: e.toString()));
    }
  }
}