import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/enums/screen_enum.dart';

final AutoDisposeStateNotifierProvider<BottomNavBarState, Object?>
    bottomNavProvider = StateNotifierProvider.autoDispose(
        (AutoDisposeStateNotifierProviderRef<BottomNavBarState, Object?> ref) {
  return BottomNavBarState(ScreenEnum.wars);
});

class BottomNavBarState extends StateNotifier<ScreenEnum> {
  BottomNavBarState(super.state);

  set value(ScreenEnum screen) => state = screen;

  ScreenEnum get value => state;

  void setAndPersistValue(ScreenEnum screen) {
    value = screen;
  }
}
