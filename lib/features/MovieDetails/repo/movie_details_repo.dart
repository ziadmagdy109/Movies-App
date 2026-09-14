import 'package:movies_app/features/MovieDetails/service/movie_details_web_service.dart';

import '../model/movies_details.dart';

class MovieDetailsRepo {
  late final MovieDetailsWebService moviesWebService;

  MovieDetailsRepo({required this.moviesWebService});

  Future<MoviesDetails> getMovieDetails(int movieId) async {
    return await moviesWebService.getMovieDetails(movieId);
  }
}