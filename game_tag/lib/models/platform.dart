class Platform {
  final String id;
  final String name;
  final int type;

  Platform({
    required this.id,
    required this.name,
    required this.type,
  });

  factory Platform.fromMap(Map<String, dynamic> map) {
    return Platform(
      id: map['objectId'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? 0,
    );
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ type.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Platform &&
        other.id == id &&
        other.name == name &&
        other.type == type;
  }
}
