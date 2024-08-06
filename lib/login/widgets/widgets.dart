import 'package:buzz/login/cubit/login_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) => context.read<LoginCubit>().emailChanged('$email@LaRe.de'),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: 'Name',
            helperText: 'Pleas enter your name',
            errorText:
                state.email.displayError != null ? 'please enter a Name' : null,
          ),
        );
      },
    );
  }
}

class PasswordInput extends StatelessWidget {
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
        );
      },
    );
  }
}

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: const Color(0xFFFFD600),
                ),
                onPressed: state.isValid
                    ? () => context.read<LoginCubit>().logInWithCredentials()
                    : null,
                child: const Text('LOGIN'),
              );
      },
    );
  }
}

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('signUpForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.orangeAccent,
                ),
                onPressed: state.isValid
                    ? () => context.read<LoginCubit>().signUpFormSubmitted()
                    : null,
                child: const Text('SIGN UP'),
              );
      },
    );
  }
}

class TeamBuilder extends StatelessWidget{
  @override
  Widget build(BuildContext){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('teams').snapshots(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          final teams = snapshot.data!.docs;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: teams.length,
            itemBuilder: (context, index){
              final team = teams[index];
              return TeamTile(teamName: team['name']);
            },
          );
        } else if(snapshot.hasError){
          return Text('Error: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class TeamTile extends StatelessWidget{
  final String teamName;

  const TeamTile({
    required this.teamName,
    });

  @override
  Widget build(BuildContext context){
    return Column(
                children: [
                  const SizedBox(height: 16.0),
                    ExpansionTile(
                      onExpansionChanged: (value) => context.read<LoginCubit>().teamNameChanged(teamName),
                      leading: const Icon(FontAwesomeIcons.users),
                      backgroundColor: const Color.fromARGB(255, 211, 210, 210),
                      collapsedBackgroundColor: const Color.fromARGB(255, 211, 210, 210),
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
                        NameInput(),
                        const SizedBox(height: 16.0),
                        SignUpButton(),
                        ],
                      ),
                      )
                    ],
                    ),
                    
                ],
              );
  }
}

class AdminTile extends StatelessWidget{
 
  @override
  Widget build(BuildContext context){
    return Column(
                children: [
                  const SizedBox(height: 16.0),
                    ExpansionTile(
                      onExpansionChanged: (value) => context.read<LoginCubit>().emailChanged('lastresort@lare.de'),
                      leading: const Icon(FontAwesomeIcons.users),
                      backgroundColor: const Color.fromARGB(255, 211, 210, 210),
                      collapsedBackgroundColor: const Color.fromARGB(255, 211, 210, 210),
                      tilePadding: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                        ),
                      collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      ),
                    title: const Center(
                      child: Text(
                      'Admin',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                    children: [
                      Form(
                      child: Column(
                        children: [
                        PasswordInput(),
                        const SizedBox(height: 16.0),
                        LoginButton(),
                        ],
                      ),
                      )
                    ],
                    ),
                    
                ],
              );
  }
}