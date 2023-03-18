import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:more_useful_clash_of_clans/ui/screens/second_screen.dart';
import 'package:more_useful_clash_of_clans/ui/screens/wars_screen.dart';

import '../../states/widgets/bottom_nav_bar/bottom_nav_bar_state.dart';
import '../../utils/enums/screen_enum.dart';
import '../widgets/app_bar_builder.dart';
import '../widgets/app_floating_action_button.dart';
import '../widgets/bottom_nav_bar.dart';
import 'clans_screen.dart';
import 'first_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ScreenEnum? navScreen = ref.watch(bottomNavProvider) as ScreenEnum?;
    const List<Widget> pageNavigation = <Widget>[
      ClansScreen(),
      WarsScreen(),
      FirstScreen(),
      SecondScreen(),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBarBuilder(context, ref),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: SafeArea(
          child: IndexedStack(
            index: navScreen?.index ?? 0,
            children: pageNavigation,
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible:
            navScreen == ScreenEnum.clans || navScreen == ScreenEnum.players,
        child: const AppFloatingActionButton(),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
