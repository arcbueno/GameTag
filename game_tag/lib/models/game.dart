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

  String get ratingReaction => GameUtils.getRatingReaction(rating);

  Game({
    required this.id,
    required this.title,
    this.publisher,
    this.rating,
    this.hoursPlayed,
    required this.state,
    required this.platform,
  });

  Game copyWith({
    String? id,
    String? title,
    String? publisher,
    double? rating,
    int? hoursPlayed,
    GameState? state,
    Platform? platform,
  }) {
    return Game(
      id: id ?? this.id,
      title: title ?? this.title,
      publisher: publisher ?? this.publisher,
      rating: rating ?? this.rating,
      hoursPlayed: hoursPlayed ?? this.hoursPlayed,
      state: state ?? this.state,
      platform: platform ?? this.platform,
    );
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['objectId'] ?? '',
      title: map['Title'] ?? '',
      publisher: map['Publisher'],
      rating: map['Rating']?.toDouble(),
      hoursPlayed: map['HoursPlayed']?.toDouble(),
      platform: Platform.fromMap(map['Platform']),
      state: GameState.fromMap(map['State']),
    );
  }
}
