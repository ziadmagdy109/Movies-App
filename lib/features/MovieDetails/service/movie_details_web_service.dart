import 'package:dio/dio.dart';

import '../../../core/utils/api_list.dart';
import '../model/movies_details.dart';

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
}