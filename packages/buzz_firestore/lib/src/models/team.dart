import 'package:buzz_repository/buzz_firestore.dart';
import 'package:equatable/equatable.dart';

class Team extends Equatable {
  Team({this.name = '', this.points = 0, List<Player> players = const []})
      : players = List.unmodifiable(players);

  final String name;
  final int points;
  final List<Player> players;

  @override
  List<Object> get props => [name, points, players];

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      name: json['name'] as String,
      points: json['points'] as int,
      players: (json['players'] as List)
          .map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'points': points,
      'players': players.map((e) => e.toJson()).toList(),
    };
  }
}
