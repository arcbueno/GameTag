class GameState {
  final String id;
  final String name;
  final GameStateType type;

  GameState({
    required this.id,
    required this.name,
    required this.type,
  });

  factory GameState.fromMap(Map<String, dynamic> map) {
    return GameState(
      id: map['objectId'] ?? '',
      name: map['name'] ?? '',
      type: GameStateType.fromJson(map['type'] ?? -1),
    );
  }
}

enum GameStateType {
  toPlay,
  playing,
  completed;

  const GameStateType();
  factory GameStateType.fromJson(int data) {
    switch (data) {
      case 0:
        return toPlay;
      case 1:
        return playing;
      case 2:
        return completed;
      default:
        return toPlay;
    }
  }
}
