import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/providers/screen_provider.dart';
import 'package:provider/provider.dart';

import '../../component/app_bar/app_bar_component.dart';
import '../../component/app_body_builder/app_body_builder.dart';
import '../../component/app_bottom_navigation_bar/app_bottom_floating_action_button.dart';
import '../../component/app_bottom_navigation_bar/app_bottom_navigation_bar_fab.dart';
import '../../utils/enums/screen_enum.dart';
import '../../providers/localization_provider.dart';
import '../../providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (_, localizationProviderRef, __) {
        return Consumer<ThemeProvider>(
          builder: (_, themeProviderRef, __) {
            return Consumer<ScreenProvider>(
              builder: (_, screenProviderRef, __) {
                return Scaffold(
                  appBar: appBarComponent(
                      context, themeProviderRef, screenProviderRef),
                  body: const SafeArea(
                    child: AppBodyBuilder(),
                  ),
                  floatingActionButton: Visibility(
                    visible: screenProviderRef.currentScreen ==
                            ScreenEnum.Clans ||
                        screenProviderRef.currentScreen == ScreenEnum.Players,
                    child: const AppBottomFloatingActionButton(),
                  ),
                  bottomNavigationBar: const AppBottomNavigationBarFab(),
                );
              },
            );
          },
        );
      },
    );
  }
}
