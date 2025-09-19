class Movie {
  final int page;
  final List<Results> results;

  Movie({required this.page, required this.results});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      page: json['page'] as int,
      results: (json['results'] as List<dynamic>)
          .map((item) => Results.fromJson(item))
          .toList(),
    );
  }
}

class Results {
  final int id;
  final String title;
  final String overview;
  final String releaseDate;
  final String? posterPath;
  int? heroTag;

  Results({
    required this.id,
    required this.title,
    required this.overview,
    required this.releaseDate,
    this.posterPath,
    this.heroTag,
  });

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
      id: json['id'] as int,
      title: json['title'] as String,
      overview: json['overview'] as String,
      releaseDate: json['release_date'] as String,
      posterPath: json['poster_path'] as String?,
    );
  }
}