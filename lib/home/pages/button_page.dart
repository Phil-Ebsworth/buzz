import 'package:buzz/app/bloc/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonPage extends StatelessWidget {
  ButtonPage({super.key});

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
                    'email': user.email,
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
                child: Text('Press me',
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context)
                            .unselectedWidgetColor
                            .withOpacity(.5))),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
                onPressed: () {
                  buzzCollection.get().then((QuerySnapshot querySnapshot) {
                    for (var doc in querySnapshot.docs) {
                      doc.reference.delete();
                    }
                  });
                },
                child: const Text('Delete all buzzes')),
          ],
        ),
      ),
    );
  }
}
