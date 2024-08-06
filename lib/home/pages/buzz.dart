import 'package:cloud_firestore/cloud_firestore.dart';

class Buzz {
  final String username;
  final String useremail;
  final Timestamp timestamp;

  Buzz({required this.username, required this.useremail, required this.timestamp});

  Future<void> saveToFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('buzzes').add({
        'username': username,
        'useremail': useremail,
        'timestamp': timestamp,
      });
      print('Buzz saved to Firestore successfully!');
    } catch (e) {
      print('Error saving buzz to Firestore: $e');
    }
  }
}

Future<List<Buzz>> getBuzzesFromFirestore() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('buzzes').get();
    List<Buzz> buzzes = [];
    querySnapshot.docs.forEach((doc) {
      Buzz buzz = Buzz(
        username: doc['username'],
        useremail: doc['useremail'],
        timestamp: doc['timestamp'],
      );
      buzzes.add(buzz);
    });
    return buzzes;
  } catch (e) {
    print('Error getting buzzes from Firestore: $e');
    return [];
  }
}