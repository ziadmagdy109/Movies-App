class CastModel {
  String? name;
  String? characterName;
  String? urlSmallImage;
  String? imdbCode;

  CastModel({
    this.name,
    this.characterName,
    this.urlSmallImage,
    this.imdbCode,
  });

  CastModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    characterName = json['character_name'];
    urlSmallImage = json['url_small_image'];
    imdbCode = json['imdb_code'];
  }
}