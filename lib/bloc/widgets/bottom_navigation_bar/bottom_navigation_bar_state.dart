part of 'bottom_navigation_bar_cubit.dart';

class BottomNavigationBarState extends Equatable {
  final ScreenEnum screenType;
  final int index;

  const BottomNavigationBarState(this.screenType, this.index);

  @override
  List<Object> get props => [screenType, index];
}
