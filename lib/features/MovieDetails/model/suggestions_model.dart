class SuggestedMovieModel {
  final String image;
  final double rating;
final int id;

  SuggestedMovieModel({
    required this.image,
    required this.rating,
    required this.id,
  });

  factory SuggestedMovieModel.fromJson(Map<String, dynamic> json) {
    final Object? rawRating = json['rating'];
    final Object? rawId = json['id'];
    return SuggestedMovieModel(
      id: rawId is num ? rawId.toInt() : 0,
      image: json['medium_cover_image'] as String? ?? '',
      rating: rawRating is num
          ? rawRating.toDouble()
          : num.tryParse('${rawRating ?? ''}')?.toDouble() ?? 0,
    );
  }
}