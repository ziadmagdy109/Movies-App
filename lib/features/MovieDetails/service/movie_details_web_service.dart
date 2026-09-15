import 'package:dio/dio.dart';

import '../../../core/utils/api_list.dart';
import '../model/movies_details.dart';
import '../model/suggestions_model.dart';

class MovieDetailsWebService {

  final dio = Dio();
  Future<MoviesDetails> getMovieDetails(int movieId) async {
    try {
      final response = await dio.get(ApiList.movieDetails, queryParameters: {'movie_id': movieId, 'with_images': true, 'with_cast': true});
      final movieJson=response.data['data']['movie'];
      return MoviesDetails.fromJson(movieJson);
    } catch (e) {
      rethrow;
    }
  }
  Future<List<SuggestedMovieModel>> getMovieSuggestions(int movieId) async {
    final response = await dio.get(
      ApiList.movieSuggestions,
      queryParameters: {
        'movie_id': movieId,
      },
    );

    final movies = response.data['data']['movies'] as List;

    return movies
        .map((movie) => SuggestedMovieModel.fromJson(movie))
        .toList();
  }
}