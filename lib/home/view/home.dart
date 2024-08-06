import 'package:buzz/app/bloc/app_bloc.dart';
import 'package:buzz/home/bloc/navigation_bloc.dart';
import 'package:buzz/home/bloc/navigation_event.dart';
import 'package:buzz/home/bloc/navigation_state.dart';
import 'package:buzz/home/pages/button_page.dart';
import 'package:buzz/home/pages/teams_page.dart';
import 'package:buzz/home/pages/overview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return BlocProvider(
      create: (context) => NavigationBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                context.read<AppBloc>().add(AppLogoutRequested());
              },
            ),
          ],
        ),
        body: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            if (state is PageLoaded) {
              switch (state.index) {
                case 0:
                  return ButtonPage();
                case 1:
                  return OverviewPage();
                case 2:
                  return TeamsPage();
                default:
                  return ButtonPage();
              }
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
        bottomNavigationBar: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            return BottomNavigationBar(
              currentIndex: state is PageLoaded ? state.index : 0,
              onTap: (index) {
                BlocProvider.of<NavigationBloc>(context).add(PageTapped(index));
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.radio_button_on), label: 'Buzzer'),
                BottomNavigationBarItem(icon: Icon(Icons.add_chart), label: 'Overview'),
                BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Teams'),
              ],
            );
          },
        ),
      ),
    );
  }
}