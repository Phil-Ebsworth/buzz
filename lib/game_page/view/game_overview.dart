import 'package:buzz/game_page/bloc/game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameOverView extends StatelessWidget {
  const GameOverView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Game Over', style: TextStyle(fontSize: 30)),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  context.read<GameBloc>().add(GameReset());
                },
                child: const Text('Back to Home'),
              ),
            ],
          ),
        );
      },
    );
  }
}
