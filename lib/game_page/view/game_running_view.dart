import 'package:buzz/game_page/bloc/game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameRunningPage extends StatelessWidget {
  const GameRunningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(builder: (context, state) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 300),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(24),
                  backgroundColor: Colors.blueGrey),
              child: ElevatedButton(
                onPressed: () {
                  context.read<GameBloc>().add(NextTeam());
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(300, 300),
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(10),
                    backgroundColor: Colors.red),
                child: const Icon(Icons.arrow_forward),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    });
  }
}
