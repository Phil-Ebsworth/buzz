import 'dart:math';

import 'package:buzz/game_page/bloc/game_bloc.dart';
import 'package:buzz/game_page/view/game_init_view.dart';
import 'package:buzz/game_page/view/game_overview.dart';
import 'package:buzz/game_page/view/game_running_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is TeamInit) {
          return GameInitPage();
        } else if (state is GameRunning) {
          return const GameRunningPage();
        } else if (state is GameOver) {
          return const GameOverView();
        } else {
          return Center(
            child: ElevatedButton(
                onPressed: () {
                  context.read<GameBloc>().add(TeamSelectionStart());
                },
                child: const Text('Start a new game')),
          );
        }
      },
    );
  }
}
