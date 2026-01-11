class InterestModel {
  final String id;
  final String name;
  final String type; // 'tech', 'career', 'personal', 'academic'
  final String? icon;
  final DateTime createdAt;

  InterestModel({
    required this.id,
    required this.name,
    required this.type,
    this.icon,
    required this.createdAt,
  });

  factory InterestModel.fromJson(Map<String, dynamic> json) {
    return InterestModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      icon: json['icon'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'icon': icon,
      'created_at': createdAt.toIso8601String(),
    };
  }
}