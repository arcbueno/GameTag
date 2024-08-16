import 'package:game_tag/models/game.dart';

sealed class HomeState {
  HomeState._();
}

class LoadingHomeState extends HomeState {
  LoadingHomeState() : super._();
}

class SuccessHomeState extends HomeState {
  final List<Game> items;

  SuccessHomeState(this.items) : super._();
}

class ErrorHomeState extends HomeState {
  final String errorMessage;

  ErrorHomeState(this.errorMessage) : super._();
}
