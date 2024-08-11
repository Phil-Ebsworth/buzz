import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/models.dart';

class BuzzFirestore {
  BuzzFirestore(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Buzz> get buzzCollection =>
      _firestore.collection('buzzes').withConverter<Buzz>(
            fromFirestore: (snapshot, _) => Buzz.fromJson(snapshot.data()!),
            toFirestore: (buzz, _) => buzz.toJson(),
          );

  CollectionReference<Player> get playerCollection =>
      _firestore.collection('players').withConverter<Player>(
            fromFirestore: (snapshot, _) => Player.fromJson(snapshot.data()!),
            toFirestore: (player, _) => player.toJson(),
          );

  CollectionReference<Team> get teamCollection =>
      _firestore.collection('teams').withConverter<Team>(
            fromFirestore: (snapshot, _) => Team.fromJson(snapshot.data()!),
            toFirestore: (team, _) => team.toJson(),
          );

  Future<void> addBuzz(Buzz buzz) async {
    await buzzCollection.add(buzz);
  }

  Future<void> addPlayer(Player player) async {
    await playerCollection.add(player);
  }

  Future<void> addTeam(Team team) async {
    await teamCollection.add(team);
  }

  Stream<List<Buzz>> buzzes() {
    return buzzCollection
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<List<Player>> players() {
    return playerCollection
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<List<Team>> teams() {
    return teamCollection
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<QuerySnapshot<Team>> teamsSnapshot() {
    return teamCollection.snapshots();
  }

  Future<void> updateBuzz(Buzz buzz) async {
    await buzzCollection.doc(buzz.timestamp.toString()).set(buzz);
  }

  Future<void> updatePlayer(Player player) async {
    await playerCollection.doc(player.email).set(player);
  }

  Future<void> updateTeam(Team team) async {
    await teamCollection.doc(team.name).set(team);
  }

  Future<void> deleteBuzz(Buzz buzz) async {
    await buzzCollection.doc(buzz.timestamp.toString()).delete();
  }

  Future<void> deletePlayer(Player player) async {
    await playerCollection.doc(player.email).delete();
  }

  Future<void> deleteTeam(Team team) async {
    await teamCollection.doc(team.name).delete();
  }

  Future<void> deleteAllBuzzes() async {
    final buzzes = await buzzCollection.get();
    for (final buzz in buzzes.docs) {
      await buzz.reference.delete();
    }
  }

  Future<void> deleteAllPlayers() async {
    final players = await playerCollection.get();
    for (final player in players.docs) {
      await player.reference.delete();
    }
  }

  Future<void> deleteAllTeams() async {
    final teams = await teamCollection.get();
    for (final team in teams.docs) {
      await team.reference.delete();
    }
  }

  Future<Player?> getPlayerByEmail(String email) async {
    final querySnapshot =
        await playerCollection.where('email', isEqualTo: email).get();
    final playerDoc = querySnapshot.docs.firstOrNull;
    if (playerDoc != null) {
      return Player.fromJson(playerDoc.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }
}
