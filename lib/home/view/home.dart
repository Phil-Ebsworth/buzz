import 'package:buzz/app/bloc/app_bloc.dart';
import 'package:buzz/game_page/bloc/game_bloc.dart';
import 'package:buzz/game_page/view/game_view.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBloc>(
          create: (context) => NavigationBloc(),
        ),
        BlocProvider<GameBloc>(
          create: (context) => GameBloc(),
        ),
      ],
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Home'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: () {
                    context.read<AppBloc>().add(AppLogoutRequested(state.user));
                  },
                ),
              ],
            ),
            body: BlocBuilder<NavigationBloc, NavigationState>(
              builder: (context, state) {
                if (state is PageLoaded) {
                  switch (state.index) {
                    case 0:
                      return const GameView();
                    case 1:
                      return OverviewPage();
                    case 2:
                      return TeamsPage();
                    case 3:
                      return ButtonPage();
                    default:
                      return const GameView();
                  }
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            bottomNavigationBar: BlocBuilder<NavigationBloc, NavigationState>(
              builder: (context, state) {
                return BottomNavigationBar(
                  currentIndex: state is PageLoaded ? state.index : 0,
                  onTap: (index) {
                    BlocProvider.of<NavigationBloc>(context)
                        .add(PageTapped(index));
                  },
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.play_arrow), label: 'Game'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.add_chart), label: 'Overview'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.group), label: 'Teams'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.radio_button_on), label: 'Buzzer'),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
