import 'package:movies_app/features/Home/data/models/movies.dart';
import 'package:movies_app/features/Search/data/service/search_web_service.dart';

class SearchRepository {
  final SearchWebService searchWebService;

  SearchRepository({required this.searchWebService});

  Future<List<Movies>> searchAllMovies(String query) async {
    final movies = await searchWebService.searchAllMovies(query);
    return movies.map((movie) => Movies.fromJson(movie)).toList();
  }
}