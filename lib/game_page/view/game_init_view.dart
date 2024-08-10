import 'package:buzz/game_page/bloc/game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameInitPage extends StatefulWidget {
  @override
  _GameInitPageState createState() => _GameInitPageState();
}

class _GameInitPageState extends State<GameInitPage> {
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();

  @override
  void dispose() {
    _teamNameController.dispose();
    super.dispose();
  }

  void _submitTeam() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      FirebaseFirestore.instance.collection('teams').add({
        'name': _teamNameController.text,
      }).then((value) {
        _teamNameController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _teamNameController,
                decoration: const InputDecoration(
                  labelText: 'Add new Team',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a team name';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  _submitTeam();
                },
              ),
              SizedBox(height: 16.0),
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('teams').snapshots(),
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
                            title: Text(teamName),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                team.reference.delete();
                              },
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              BlocBuilder<GameBloc, GameState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      context.read<GameBloc>().add(const GameStarted(1));
                    },
                    child: const Text('Start Game'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
