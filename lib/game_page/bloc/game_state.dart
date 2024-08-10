part of 'game_bloc.dart';

sealed class GameState extends Equatable {
  const GameState();

  @override
  List<Object> get props => [];
}

class TeamInit extends GameState {}

class GameRunning extends GameState {
  final int round;

  const GameRunning(this.round);

  @override
  List<Object> get props => [round];
}

class GameOver extends GameState {}

final class GameInitial extends GameState {}
