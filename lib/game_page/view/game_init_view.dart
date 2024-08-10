import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      // Add the team to Firestore collection named 'teams'
      FirebaseFirestore.instance.collection('teams').add({
        'name': _teamNameController.text,
      }).then((value) {
        // Clear the form field after successful submission
        _teamNameController.clear();
      }).catchError((error) {
        // Handle any errors that occur during submission
        print('Error submitting team: $error');
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
                decoration: InputDecoration(
                  labelText: 'Team Name',
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
                          );
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error loading teams');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  // Delete all teams from Firestore collection named 'teams'
                  FirebaseFirestore.instance
                      .collection('teams')
                      .get()
                      .then((snapshot) {
                    for (var doc in snapshot.docs) {
                      doc.reference.delete();
                    }
                  }).catchError((error) {
                    // Handle any errors that occur during deletion
                    print('Error deleting teams: $error');
                  });
                },
                child: Text('Delete All Teams'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
