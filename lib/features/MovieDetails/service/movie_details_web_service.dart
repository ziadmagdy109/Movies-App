import 'package:dio/dio.dart';

import '../../../core/utils/api_list.dart';
import '../model/movies_details.dart';
import '../model/suggestions_model.dart';

class MovieDetailsWebService {
  final Dio dio;

  MovieDetailsWebService()
      : dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            receiveDataWhenStatusError: true,
          ),
        );

  Future<MoviesDetails> getMovieDetails(int movieId) async {
    final response = await dio.get(
      ApiList.movieDetails,
      queryParameters: {
        'movie_id': movieId,
        'with_images': true,
        'with_cast': true,
      },
    );

    final Object? data = response.data;
    final Object? movieJson = data is Map<String, dynamic>
        ? data['data'] is Map<String, dynamic>
            ? (data['data'] as Map<String, dynamic>)['movie']
            : null
        : null;

    if (movieJson is! Map<String, dynamic>) {
      throw Exception('Invalid movie details response');
    }
    return MoviesDetails.fromJson(movieJson);
  }

  Future<List<SuggestedMovieModel>> getMovieSuggestions(int movieId) async {
    final response = await dio.get(
      ApiList.movieSuggestions,
      queryParameters: {'movie_id': movieId},
    );

    final Object? data = response.data;
    final Object? movies = data is Map<String, dynamic>
        ? data['data'] is Map<String, dynamic>
            ? (data['data'] as Map<String, dynamic>)['movies']
            : null
        : null;

    if (movies is! List) {
      throw Exception('Invalid movie suggestions response');
    }
    return movies
        .whereType<Map<String, dynamic>>()
        .map((movie) => SuggestedMovieModel.fromJson(movie))
        .toList();
  }
}