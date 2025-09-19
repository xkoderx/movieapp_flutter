class CastCrew {
  final int? id;
  final String name;
  final String subName;
  final String? imagePath;
  final String personType;

  CastCrew({
    required this.id,
    required this.name,
    required this.subName,
    this.imagePath,
    required this.personType,
  });
}