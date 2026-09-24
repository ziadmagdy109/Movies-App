import 'package:movies_app/features/MovieDetails/service/movie_details_web_service.dart';

import '../model/movies_details.dart';
import '../model/suggestions_model.dart';
class MovieDetailsRepo {
  final MovieDetailsWebService moviesWebService;

  MovieDetailsRepo({required this.moviesWebService});

  Future<MoviesDetails> getMovieDetails(int movieId) async {
    return moviesWebService.getMovieDetails(movieId);
  }

  Future<List<SuggestedMovieModel>> getMovieSuggestions(int movieId) async {
    return moviesWebService.getMovieSuggestions(movieId);
  }
}