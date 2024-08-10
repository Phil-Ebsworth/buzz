import 'package:buzz/login/cubit/login_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NameInput extends StatelessWidget {
  const NameInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
            key: const Key('loginForm_emailInput_textField'),
            onChanged: (name) {
              context.read<LoginCubit>().nameChanged(name.toLowerCase());
              context
                  .read<LoginCubit>()
                  .emailChanged('${name.toLowerCase()}@lare.de');
            },
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: 'Name',
              helperText: 'Please enter your name',
              errorText: state.email.displayError != null
                  ? 'please enter your name'
                  : null,
            ),
            onSubmitted: (value) {
              context.read<LoginCubit>().signUpFormSubmitted();
            });
      },
    );
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'password',
            helperText: '',
            errorText:
                state.password.displayError != null ? 'invalid password' : null,
          ),
          onSubmitted: (value) =>
              context.read<LoginCubit>().logInWithCredentials(),
        );
      },
    );
  }
}

class TeamBuilder extends StatelessWidget {
  const TeamBuilder({super.key});

  @override
  Widget build(context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('teams').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final teams = snapshot.data!.docs;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: teams.length,
            itemBuilder: (context, index) {
              final team = teams[index];
              return LoginTile.team(teamName: team['name']);
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

enum TileType { admin, team }

class LoginTile extends StatelessWidget {
  final String email;
  final String password;
  final String teamName;
  final TileType tileType;

  const LoginTile.team({
    super.key,
    required this.teamName,
    this.email = '',
    this.password = 'password',
    this.tileType = TileType.team,
  });

  const LoginTile.admin({
    super.key,
    this.teamName = 'Last Resort',
    this.email = 'lastresort@lare.de',
    this.password = '',
    this.tileType = TileType.admin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16.0),
        ExpansionTile(
          onExpansionChanged: (value) {
            if (tileType == TileType.team) {
              context.read<LoginCubit>().teamNameChanged(teamName);
            } else {
              context.read<LoginCubit>().emailChanged(email);
            }
          },
          leading: const Icon(FontAwesomeIcons.users),
          tilePadding: const EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Center(
            child: Text(
              teamName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          children: [
            Form(
              child: Column(
                children: [
                  if (tileType == TileType.team)
                    const NameInput()
                  else
                    const PasswordInput(),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
