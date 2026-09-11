import 'package:bloc/bloc.dart';
import 'package:movies_app/features/Home/data/models/movies.dart';
import 'package:movies_app/features/Home/data/repository/movies_repository.dart';
import 'package:movies_app/features/Home/presentation/cubit/movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  final MoviesRepository moviesRepository;

  List<Movies> allMovies = [];
  List<Movies> categoryMovies = [];

  final List<String> categories = [
    'Drama',
    'Action',
    'Comedy',
    'Horror',
    'Romance',
  ];

  int currentCategoryIndex = 0;

  MoviesCubit({required this.moviesRepository}) : super(moviesInitial());

  Future<void> getMovies(String genre) async {
    emit(moviesLoading());

    try {
      final allMovies = await moviesRepository.getAllMovies();

      final categoryMovies = await moviesRepository.getMoviesByGenre(genre);

      this.allMovies = allMovies;
      this.categoryMovies = categoryMovies;

      emit(
        moviesLoaded(
          allMovies: allMovies,
          categoryMovies: categoryMovies,
          category: genre,
        ),
      );
    } catch (e) {
      emit(moviesFailure(msg: e.toString()));
    }
  }

  Future<void> getNextCategoryMovies() async {
    currentCategoryIndex = (currentCategoryIndex + 1) % categories.length;

    final nextCategory = categories[currentCategoryIndex];

    await getMovies(nextCategory);
  }
}
