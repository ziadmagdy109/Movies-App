import 'package:bloc/bloc.dart';
import 'package:movies_app/features/Home/data/models/movies.dart';
import 'package:movies_app/features/Home/data/repository/movies_repository.dart';
import 'package:movies_app/features/Home/presentation/cubit/movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  final MoviesRepository moviesRepository;
  List<Movies> movies = [];

  MoviesCubit({required this.moviesRepository}) : super(moviesInitial());

  List<Movies> getMovies() {
    moviesRepository.getMovies().then((movies) {
      emit(moviesLoaded(allMovies: movies));
      this.movies = movies;
    });

    return movies;
  }
}
