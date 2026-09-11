import 'package:movies_app/features/Home/data/models/movies.dart';
import 'package:movies_app/features/Home/data/service/movies_web_service.dart';

class MoviesRepository {
  final MoviesWebService moviesWebService;
  MoviesRepository({required this.moviesWebService});

  Future<List<Movies>> getAllMovies() async {
    final movies = await moviesWebService.getAllMovies();
    return movies.map((movie) => Movies.fromJson(movie)).toList();
  }

  Future<List<Movies>> getMoviesByGenre(String genre) async {
    final movies = await moviesWebService.getMoviesByGenre(genre);
    return movies.map((movie) => Movies.fromJson(movie)).toList();
  }
}
