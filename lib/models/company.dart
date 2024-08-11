class Company {
  final String id;
  final String name;
  final int averageHealthRating;

  Company({
    required this.id,
    required this.name,
    required this.averageHealthRating,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      averageHealthRating: json['averageHealthRating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'averageHealthRating': averageHealthRating,
    };
  }
}
