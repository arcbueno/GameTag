class GameState {
  final String id;
  final String name;
  final int type;

  GameState({
    required this.id,
    required this.name,
    required this.type,
  });

  factory GameState.fromMap(Map<String, dynamic> map) {
    return GameState(
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

    return other is GameState &&
        other.id == id &&
        other.name == name &&
        other.type == type;
  }
}
