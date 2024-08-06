import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('buzzes')
          .orderBy('time')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final buzzes = snapshot.data!.docs;

        return ListView.builder(
          itemCount: buzzes.length,
          itemBuilder: (context, index) {
            final buzz = buzzes[index].data() as Map<String, dynamic>;
            return ListTile(
              title: Text(buzz['user']),
              subtitle: Text(buzz['email']),
              trailing: Text(buzz['time'].toDate().toString().substring(11,19)),
            );
          },
        );
      },
    );
  }
}