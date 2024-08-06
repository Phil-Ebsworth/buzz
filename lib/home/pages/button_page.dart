import 'package:buzz/app/bloc/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonPage extends StatelessWidget {
  final CollectionReference buzzCollection =
      FirebaseFirestore.instance.collection('buzzes');

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 300),
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(24),
                  backgroundColor: Colors.blueGrey
            
                ),
                child:  ElevatedButton(
                onPressed: () {
                  buzzCollection.add({
                    'time': DateTime.now(),
                    'user': user.name ?? "Anonymous",
                    'email': user.email,
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 300),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10),
                  backgroundColor: Colors.red
                ),
                child: Text('Press me'),
              ),
              ),
              const SizedBox(height: 20,),
            ElevatedButton(onPressed: () {
                  buzzCollection.get().then((snapshot) {
                    for (DocumentSnapshot doc in snapshot.docs) {
                      doc.reference.delete();
                    }
                  });
                }, child: Text('delete'),)
          ],
        ),
      ),
    );
  }
}