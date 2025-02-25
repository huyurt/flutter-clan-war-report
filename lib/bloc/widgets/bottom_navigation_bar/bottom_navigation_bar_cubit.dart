import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:clan_war_report/utils/enums/screen_enum.dart';

part 'bottom_navigation_bar_state.dart';

class BottomNavigationBarCubit extends Cubit<BottomNavigationBarState> {
  BottomNavigationBarCubit()
      : super(const BottomNavigationBarState(ScreenEnum.wars, 0));

  void setScreen(ScreenEnum screenType) {
    int index = ScreenEnum.values.indexOf(screenType);
    emit(BottomNavigationBarState(screenType, index));
  }
}
