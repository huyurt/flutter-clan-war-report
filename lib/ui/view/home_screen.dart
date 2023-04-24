import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:more_useful_clash_of_clans/ui/view/setting_screen.dart';
import 'package:more_useful_clash_of_clans/ui/view/clans_current_war_screen.dart';

import '../../bloc/widgets/bottom_navigation_bar/bottom_navigation_bar_cubit.dart';
import '../../utils/enums/screen_enum.dart';
import '../widgets/app_bar_builder.dart';
import '../widgets/app_floating_action_button.dart';
import '../widgets/bottom_nav_bar.dart';
import 'clans_screen.dart';
import 'players_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> pageNavigation = [
      ClansCurrentWarScreen(
        key: PageStorageKey(ScreenEnum.wars.name),
      ),
      ClansScreen(
        key: PageStorageKey(ScreenEnum.clans.name),
      ),
      PlayersScreen(
        key: PageStorageKey(ScreenEnum.players.name),
      ),
      SettingScreen(
        key: PageStorageKey(ScreenEnum.setting.name),
      ),
    ];

    return BlocBuilder<BottomNavigationBarCubit, BottomNavigationBarState>(
        builder: (context, state) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: appBarBuilder(context, state.screenType),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: SafeArea(
            child: pageNavigation[state.index],
          ),
        ),
        floatingActionButton: Visibility(
          visible: state.screenType == ScreenEnum.clans ||
              state.screenType == ScreenEnum.players,
          child: const AppFloatingActionButton(),
        ),
        bottomNavigationBar: const BottomNavBar(),
      );
    });
  }
}
