import 'package:buzz/app/bloc/app_bloc.dart';
import 'package:buzz/game_page/bloc/game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameRunningPage extends StatelessWidget {
  GameRunningPage({super.key});

  final CollectionReference buzzCollection =
      FirebaseFirestore.instance.collection('buzzes');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is GameRunning) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  NextTeamButton(),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LastRoundButton(),
                      const SizedBox(width: 20.0),
                      Text('Round ${state.round.toString()}',
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 20.0),
                      NextRoundButton(),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  TeamList(),
                  const SizedBox(height: 20.0),
                  EndgameButton(),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class NextTeamButton extends StatelessWidget {
  NextTeamButton({super.key});

  final CollectionReference buzzCollection =
      FirebaseFirestore.instance.collection('buzzes');
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 30,
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    buzzCollection.add({
                      'time': DateTime.now(),
                      'user': 'Admin',
                      'email': state.user.email,
                      'teamName': 'Last Resort',
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(300, 300),
                    padding: const EdgeInsets.all(10),
                    backgroundColor: Theme.of(context).primaryColor,
                    shadowColor: Colors.black,
                    elevation: 10,
                  ),
                  child: Icon(Icons.play_arrow,
                      size: 100,
                      color: Theme.of(context)
                          .unselectedWidgetColor
                          .withOpacity(.5)),
                ),
              )
            ]));
      },
    );
  }
}

class TeamList extends StatelessWidget {
  TeamList({super.key});

  final CollectionReference buzzCollection =
      FirebaseFirestore.instance.collection('buzzes');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('teams').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final teams = snapshot.data!.docs;
          return Expanded(
            child: ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
                final teamName = team['name'];
                return ListTile(
                  title: Center(
                      child:
                          Text(teamName, style: const TextStyle(fontSize: 20))),
                );
              },
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class NextRoundButton extends StatelessWidget {
  NextRoundButton({super.key});

  final CollectionReference buzzCollection =
      FirebaseFirestore.instance.collection('buzzes');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(builder: (context, state) {
      if (state is GameRunning) {
        return IconButton.filled(
            onPressed: () {
              context.read<GameBloc>().add(NextRound(state.round));
            },
            icon: const Icon(Icons.navigate_next_rounded));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }
}

class LastRoundButton extends StatelessWidget {
  LastRoundButton({super.key});

  final CollectionReference buzzCollection =
      FirebaseFirestore.instance.collection('buzzes');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(builder: (context, state) {
      if (state is GameRunning) {
        return IconButton.filled(
            onPressed: () {
              context.read<GameBloc>().add(RoundBack(state.round));
            },
            icon: const Icon(Icons.navigate_before_rounded));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }
}

class EndgameButton extends StatelessWidget {
  EndgameButton({super.key});

  final CollectionReference buzzCollection =
      FirebaseFirestore.instance.collection('buzzes');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(builder: (context, state) {
      if (state is GameRunning) {
        return IconButton.filled(
            onPressed: () {
              context.read<GameBloc>().add(GameEnded());
            },
            icon: const Icon(Icons.stop_rounded));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }
}
