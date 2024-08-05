// navigation_bloc.dart
import 'package:bloc/bloc.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(PageLoaded(0)) {
    on<PageTapped>((event, emit) {
      emit(PageLoaded(event.index));
    });
  }
}