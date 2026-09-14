class ApiList {
  //https://movies-api.accel.li/api/v2/movie_details.json?movie_id=12&with_images=true&with_cast=true
  static const String baseUrl = "https://yts.gg/api/v2";
  static const String listMovies = "$baseUrl/list_movies.json";

  static const String baseUrl2 = "https://movies-api.accel.li/api/v2";
  static const String movieDetails = "$baseUrl2/movie_details.json";
}
