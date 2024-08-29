import 'package:game_tag/models/game_state.dart';
import 'package:game_tag/models/platform.dart';
import 'package:game_tag/utils/game_utils.dart';

class Game {
  final String id;
  final String title;
  final String? publisher;
  final double? rating;
  final int? hoursPlayed;
  final Platform platform;
  final GameState state;
  final List<Screenshot> screenshots;

  String get ratingReaction => GameUtils.getRatingReaction(rating);

  Game({
    required this.id,
    required this.title,
    this.publisher,
    this.rating,
    this.hoursPlayed,
    required this.state,
    required this.platform,
    this.screenshots = const [],
  });

  Game copyWith({
    String? id,
    String? title,
    String? publisher,
    double? rating,
    int? hoursPlayed,
    GameState? state,
    Platform? platform,
    List<Screenshot>? screenshots,
  }) {
    return Game(
      id: id ?? this.id,
      title: title ?? this.title,
      publisher: publisher ?? this.publisher,
      rating: rating ?? this.rating,
      hoursPlayed: hoursPlayed ?? this.hoursPlayed,
      state: state ?? this.state,
      platform: platform ?? this.platform,
      screenshots: screenshots ?? this.screenshots,
    );
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['objectId'] ?? '',
      title: map['Title'] ?? '',
      publisher: map['Publisher'],
      rating: map['Rating']?.toDouble(),
      hoursPlayed: map['hoursPlayed']?.toInt(),
      platform: Platform.fromMap(map['Platform']),
      state: GameState.fromMap(map['State']),
      screenshots: (map['Screenshots'] as Map)['edges']
              .map<Screenshot>((e) => Screenshot.fromMap(e['node']))
              .toList() ??
          [],
    );
  }
}

class Screenshot {
  final String id;
  final String url;

  Screenshot({
    required this.id,
    required this.url,
  });

  factory Screenshot.fromMap(Map<String, dynamic> map) {
    return Screenshot(
      id: map['objectId'] ?? '',
      url: map['url'] ?? '',
    );
  }
}
