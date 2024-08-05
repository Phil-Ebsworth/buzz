// navigation_state.dart
import 'package:equatable/equatable.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();
}

class PageLoading extends NavigationState {
  @override
  List<Object> get props => [];
}

class PageLoaded extends NavigationState {
  final int index;

  const PageLoaded(this.index);

  @override
  List<Object> get props => [index];
}
