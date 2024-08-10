import 'package:buzz/app/bloc/app_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: PlayerPage());

  @override
  Widget build(BuildContext context) {
    final CollectionReference buzzCollection =
        FirebaseFirestore.instance.collection('buzzes');
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed: () {
                  context.read<AppBloc>().add(AppLogoutRequested(state.user));
                },
              ),
            ],
          ),
          body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('players')
                  .where('email', isEqualTo: user.email)
                  .snapshots(),
              builder: (context, snapshot) {
                final player = snapshot.data?.docs[0]['user'] ?? "";
                final teamName = snapshot.data?.docs[0]['teamName'] ?? "";
                final email = snapshot.data?.docs[0]['email'] ?? "";
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (snapshot.hasData)
                        Column(
                          children: [
                            Text(
                              teamName,
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              player.toString().toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16.0),
                          ],
                        ),
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
                              'user': player,
                              'email': email,
                              'teamName': teamName,
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(300, 300),
                            padding: const EdgeInsets.all(10),
                            backgroundColor: Theme.of(context).primaryColor,
                            shadowColor: Colors.black,
                            elevation: 10,
                          ),
                          child: Text('Press me',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context)
                                      .unselectedWidgetColor
                                      .withOpacity(.5))),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        );
      },
    );
  }
}
