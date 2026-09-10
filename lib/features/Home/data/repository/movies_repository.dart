import 'package:movies_app/features/Home/data/models/movies.dart';
import 'package:movies_app/features/Home/data/service/movies_web_service.dart';

class MoviesRepository {
  final MoviesWebService moviesWebService;
  MoviesRepository({required this.moviesWebService});

  Future<List<Movies>> getMovies() async {
    final movies = await moviesWebService.getMovies();
    return movies.map((movie) => Movies.fromJson(movie)).toList();
  }
}
