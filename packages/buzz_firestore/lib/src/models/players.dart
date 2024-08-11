import 'package:equatable/equatable.dart';

class Player extends Equatable {
  const Player(
      {this.name = '', required this.email, this.team = '', this.points = 0});

  final String name;
  final String email;
  final String team;
  final int points;

  @override
  List<Object> get props => [name, email, team, points];

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'] as String,
      email: json['email'] as String,
      team: json['team'] as String,
      points: json['points'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'team': team,
      'points': points,
    };
  }
}
