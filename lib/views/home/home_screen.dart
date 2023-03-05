import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/localization.dart';
import '../../utils/localization/app_localizations.dart';
import '../../utils/localization/language_provider.dart';
import '../../utils/theme/theme_provider.dart';
import '../setting/setting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex1 = 0;
  final example1 = [
    'Example 1',
    'Reels',
    'New Photo',
    'Activity',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(builder: (_, languageProviderRef, __) {
      return Consumer<ThemeProvider>(builder: (_, themeProviderRef, __) {
        return Scaffold(
          body: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    floating: false,
                    forceElevated: innerBoxIsScrolled,
                    automaticallyImplyLeading: false,
                    pinned: true,
                    backgroundColor: context.scaffoldBackgroundColor,
                    elevation: 0,
                    actions: [
                      IconButton(
                        icon: Icon(Icons.settings,
                            color:
                                themeProviderRef.isDarkModeOn ? white : black),
                        onPressed: () {
                          const SettingScreen().launch(context);
                        },
                      ),
                    ],
                    title: Text(AppLocalizations.of(context)
                        .translate(Localization.Wars)),
                  ),
                ];
              },
              body: Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(AppLocalizations.of(context)
                          .translate(example1.elementAt(currentIndex1))),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (int index) {
              setState(() {
                currentIndex1 = index;
              });
            },
            currentIndex: currentIndex1,
            type: BottomNavigationBarType.fixed,
            //selectedItemColor: appStore.iconColor,
            //unselectedItemColor: appStore.textSecondaryColor,
            //backgroundColor: appStore.appBarColor,
            items: [
              //1
              BottomNavigationBarItem(
                icon: Image.asset(
                    'images/widgets/materialWidgets/mwAppStructureWidgets/BottomNavigation/home.png',
                    height: 25,
                    width: 25),
                activeIcon: Image.asset(
                    'images/widgets/materialWidgets/mwAppStructureWidgets/BottomNavigation/home_fill.png',
                    height: 25,
                    width: 25),
                label: 'Home',
              ),
              //2
              BottomNavigationBarItem(
                icon: Image.asset(
                    'images/widgets/materialWidgets/mwAppStructureWidgets/BottomNavigation/reel.png',
                    height: 25,
                    width: 25),
                activeIcon: Image.asset(
                    'images/widgets/materialWidgets/mwAppStructureWidgets/BottomNavigation/reel_fill.png',
                    height: 25,
                    width: 25),
                label: 'Reels',
              ),
              //3
              BottomNavigationBarItem(
                icon: Image.asset(
                    'images/widgets/materialWidgets/mwAppStructureWidgets/BottomNavigation/gallery.png',
                    height: 25,
                    width: 25),
                activeIcon: Image.asset(
                    'images/widgets/materialWidgets/mwAppStructureWidgets/BottomNavigation/gallery_fill.png',
                    height: 25,
                    width: 25),
                label: 'Gallery',
              ),
              //4
              BottomNavigationBarItem(
                icon: Image.asset(
                    'images/widgets/materialWidgets/mwAppStructureWidgets/BottomNavigation/heart.png',
                    height: 25,
                    width: 25),
                activeIcon: Image.asset(
                    'images/widgets/materialWidgets/mwAppStructureWidgets/BottomNavigation/heart_fill.png',
                    height: 25,
                    width: 25),
                label: AppLocalizations.of(context)
                    .translate(Localization.Activity),
              ),
            ],
          ),
        );
      });
    });
  }
}
