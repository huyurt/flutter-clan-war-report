import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/providers/screen_provider.dart';
import 'package:more_useful_clash_of_clans/utils/enums/screen_enum.dart';
import 'package:more_useful_clash_of_clans/utils/localization/app_localizations.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../providers/localization_provider.dart';
import '../../utils/constants/localization.dart';
import 'bottom_navigation_bar_item_model.dart';

class AppBottomNavigationBarFab extends StatefulWidget {
  const AppBottomNavigationBarFab({super.key});

  @override
  State<AppBottomNavigationBarFab> createState() =>
      _AppBottomNavigationBarFabState();
}

class _AppBottomNavigationBarFabState extends State<AppBottomNavigationBarFab> {
  List<BottomNavigationBarItemModel> items = [];

  @override
  void initState() {
    super.initState();
    items.add(
      BottomNavigationBarItemModel(
        title: Localization.Wars,
        launchWidget: Text('Home View', style: boldTextStyle(size: 24)),
        icon: Icons.home,
        alternateIcon: Icons.home_outlined,
      ),
    );
    items.add(
      BottomNavigationBarItemModel(
        title: Localization.Clans,
        launchWidget: Text('Search View', style: boldTextStyle(size: 24)),
        icon: Icons.search,
        alternateIcon: Icons.search,
      ),
    );
    items.add(
      BottomNavigationBarItemModel(
        title: Localization.Players,
        launchWidget: Text('Favorite View', style: boldTextStyle(size: 24)),
        icon: Icons.favorite,
        alternateIcon: Icons.favorite_outline,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (_, themeProviderRef, __) {
        return Consumer<ScreenProvider>(
          builder: (_, screenProviderRef, __) {
            return BottomAppBar(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ...List.generate(
                    items.length,
                    (index) {
                      BottomNavigationBarItemModel data = items[index];
                      return Container(
                        child: _createColumn(
                                data, screenProviderRef.currentScreen, index)
                            .onTap(() {
                          screenProviderRef
                              .changeScreen(ScreenEnum.values[index]);
                          setState(() {});
                        }).expand(),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _createColumn(
      BottomNavigationBarItemModel data, ScreenEnum selectedScreen, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8),
        ),
        selectedScreen == ScreenEnum.values[index]
            ? Icon(data.icon, size: 24)
            : Icon(data.alternateIcon, size: 24, color: Colors.grey),
        Text(
          AppLocalizations.of(context).translate(data.title.validate()),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
        ),
      ],
    );
  }
}
