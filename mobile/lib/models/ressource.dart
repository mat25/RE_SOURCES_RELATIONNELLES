class Ressource {
  final int id;
  final String name;
  final int year;
  final String color;
  final String pantoneValue;

  Ressource({
    required this.id,
    required this.name,
    required this.year,
    required this.color,
    required this.pantoneValue,
  });

  factory Ressource.fromJson(Map<String, dynamic> json) {
    return Ressource(
      id: json['id'] as int,
      name: json['name'] as String,
      year: json['year'] as int,
      color: json['color'] as String,
      pantoneValue: json['pantone_value'] as String,
    );
  }

  static List<Ressource> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Ressource.fromJson(json)).toList();
  }
}
