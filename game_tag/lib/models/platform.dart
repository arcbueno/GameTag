class Platform {
  final String id;
  final String name;
  final PlatformType type;

  Platform({
    required this.id,
    required this.name,
    required this.type,
  });

  factory Platform.fromMap(Map<String, dynamic> map) {
    return Platform(
      id: map['objectId'] ?? '',
      name: map['name'] ?? '',
      type: PlatformType.fromJson(map['type'] ?? -1),
    );
  }
}

enum PlatformType {
  xbox,
  pc,
  nintendo,
  playstation;

  const PlatformType();

  factory PlatformType.fromJson(int data) {
    switch (data) {
      case 0:
        return xbox;
      case 1:
        return pc;
      case 2:
        return nintendo;
      case 3:
        return playstation;
      default:
        return pc;
    }
  }
}
