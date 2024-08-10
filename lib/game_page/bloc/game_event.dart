part of 'game_bloc.dart';

sealed class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class TeamSelectionStart extends GameEvent {}

class GameStarted extends GameEvent {
  final int round;

  const GameStarted(this.round);

  @override
  List<Object> get props => [round];
}

class GameEnded extends GameEvent {}

class NextRound extends GameEvent {
  final int round;

  const NextRound(this.round);

  @override
  List<Object> get props => [round];
}

class RoundBack extends GameEvent {
  final int round;

  const RoundBack(this.round);

  @override
  List<Object> get props => [round];
}

class NextTeam extends GameEvent {}

class GameReset extends GameEvent {}
