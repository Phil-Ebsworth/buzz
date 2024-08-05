import 'package:buzz/home/bloc/navigation_bloc.dart';
import 'package:buzz/home/bloc/navigation_event.dart';
import 'package:buzz/home/bloc/navigation_state.dart';
import 'package:buzz/home/pages/button_page.dart';
import 'package:buzz/home/pages/profile_page.dart';
import 'package:buzz/home/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocProvider(
      create: (context) => NavigationBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            if (state is PageLoaded) {
              switch (state.index) {
                case 0:
                  return ButtonPage();
                case 1:
                  return SearchPage();
                case 2:
                  return ProfilePage();
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
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              ],
            );
          },
        ),
      ),
    );
  }
}