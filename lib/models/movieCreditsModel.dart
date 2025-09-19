class MovieCredits {
  final List<Cast> cast;
  final List<Crew> crew;

  MovieCredits({required this.cast, required this.crew});

  factory MovieCredits.fromJson(Map<String, dynamic> json) {
    return MovieCredits(
      cast: (json['cast'] as List<dynamic>)
          .map((item) => Cast.fromJson(item))
          .toList(),
      crew: (json['crew'] as List<dynamic>)
          .map((item) => Crew.fromJson(item))
          .toList(),
    );
  }
}

class Cast {
  final int? castId;
  final String name;
  final String character;
  final String? profilePath;

  Cast({
    required this.castId,
    required this.name,
    required this.character,
    this.profilePath,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      castId: json['cast_id'] as int?,
      name: json['name'] as String,
      character: json['character'] as String,
      profilePath: json['profile_path'] as String?,
    );
  }
}

class Crew {
  final int? id;
  final String name;
  final String job;
  final String? profilePath;

  Crew({
    required this.id,
    required this.name,
    required this.job,
    this.profilePath,
  });

  factory Crew.fromJson(Map<String, dynamic> json) {
    return Crew(
      id: json['id'] as int?,
      name: json['name'] as String,
      job: json['job'] as String,
      profilePath: json['profile_path'] as String?,
    );
  }
}