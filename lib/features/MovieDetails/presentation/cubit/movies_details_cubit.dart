import 'package:bloc/bloc.dart';
import 'package:movies_app/features/MovieDetails/repo/movie_details_repo.dart';
import 'movies_details_state.dart';

class MoviesDetailsCubit extends Cubit<MoviesDetailsState> {
  final MovieDetailsRepo movieDetailsRepository;

  MoviesDetailsCubit({required this.movieDetailsRepository})
    : super(MoviesInital());

  Future<void> getMovieDetails(int movieId) async {
    emit(MoviesDetailsLoading());
    try {
      final movieDetailsList = await movieDetailsRepository.getMovieDetails(
        movieId,
      );
      if (isClosed) return;
      emit(MoviesDetailsLoaded(moviesDetails: movieDetailsList));
    } catch (e) {
      if (isClosed) return;
      emit(MoviesDetailsFailure(msg: e.toString()));
    }
  }
}