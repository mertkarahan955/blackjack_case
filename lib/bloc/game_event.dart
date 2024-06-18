part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class GameStarted extends GameEvent {
  @override
  String toString() => 'GameStarted';
}

class PlayerHit extends GameEvent {
  @override
  String toString() => 'PlayerHit';
}

class PlayerStand extends GameEvent {
  @override
  String toString() => 'PlayerStand';
}

class EndRound extends GameEvent {
  @override
  String toString() => 'EndRound';
}

class ContinueGame extends GameEvent {
  @override
  String toString() => 'ContinueGame';
}

class EndGame extends GameEvent {
  @override
  String toString() => 'EndGame';
}
