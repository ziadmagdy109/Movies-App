import 'package:movies_app/features/Browse/data/service/browse_web_service.dart';
import 'package:movies_app/features/Home/data/models/movies.dart';

class BrowseRepository {
  final BrowseWebService browseWebService;

  BrowseRepository({required this.browseWebService});

  Future<List<Movies>> getMoviesByGenre(String genre) async {
    final movies = await browseWebService.getMoviesByGenre(genre);
    return movies.map((movie) => Movies.fromJson(movie)).toList();
  }
}