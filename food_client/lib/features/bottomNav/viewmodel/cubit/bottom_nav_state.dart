part of 'bottom_nav_cubit.dart';

@immutable
sealed class BottomNavState {}

final class BottomNavChanged extends BottomNavState {
  final int index;
  BottomNavChanged(this.index);
}
