import 'package:movies_app/features/Home/data/models/movies.dart';
import 'package:movies_app/features/MovieDetails/model/movies_details.dart';

class SavedMovie {
  final int id;
  final String title;
  final String image;
  final double rating;

  const SavedMovie({
    required this.id,
    required this.title,
    required this.image,
    required this.rating,
  });

  factory SavedMovie.fromJson(Map<String, dynamic> json) {
    return SavedMovie(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      image: json['image'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'rating': rating,
    };
  }

  factory SavedMovie.fromMovies(Movies movie) {
    return SavedMovie(
      id: movie.id,
      title: movie.title,
      image: movie.largeCoverImage,
      rating: movie.rating.toDouble(),
    );
  }

  factory SavedMovie.fromDetails({
    required int id,
    required MoviesDetails details,
  }) {
    return SavedMovie(
      id: id,
      title: details.title_long,
      image: details.large_cover_image,
      rating: details.rating is num
          ? (details.rating as num).toDouble()
          : num.tryParse('${details.rating ?? ''}')?.toDouble() ?? 0,
    );
  }

  Movies toMovies() {
    return Movies(
      id: id,
      rating: rating,
      largeCoverImage: image,
      title: title,
    );
  }
}