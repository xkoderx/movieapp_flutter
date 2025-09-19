class MovieDetailModel {
  final int id;
  final String title;
  final String overview;
  final int? runtime;
  final List<Genre> genres;

  MovieDetailModel({
    required this.id,
    required this.title,
    required this.overview,
    this.runtime,
    required this.genres,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailModel(
      id: json['id'] as int,
      title: json['title'] as String,
      overview: json['overview'] as String,
      runtime: json['runtime'] as int?,
      genres: (json['genres'] as List<dynamic>)
          .map((item) => Genre.fromJson(item))
          .toList(),
    );
  }
}

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}