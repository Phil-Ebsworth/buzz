import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameInitial()) {
    on<TeamSelectionStart>((event, emit) {
      emit(TeamInit());
    });
    on<GameStarted>((event, emit) {
      emit(GameRunning(1));
    });

    on<NextRound>((event, emit) {
      emit(GameRunning(event.round + 1));
    });

    on<GameEnded>((event, emit) {
      emit(GameOver());
    });

    on<NextQuestion>((event, emit) {});
  }
}
