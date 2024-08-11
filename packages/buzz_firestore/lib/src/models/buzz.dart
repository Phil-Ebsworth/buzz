import 'package:buzz_repository/buzz_firestore.dart';
import 'package:equatable/equatable.dart';

class Buzz extends Equatable {
  const Buzz(
      {required this.timestamp, required this.player, required this.team});

  final DateTime timestamp;
  final Player player;
  final Team team;

  @override
  List<Object> get props => [timestamp, player, team];

  factory Buzz.fromJson(Map<String, dynamic> json) {
    return Buzz(
      timestamp: (json['timestamp'] as DateTime),
      player: Player.fromJson(json['player'] as Map<String, dynamic>),
      team: Team.fromJson(json['team'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'player': player.toJson(),
      'team': team.toJson(),
    };
  }
}
