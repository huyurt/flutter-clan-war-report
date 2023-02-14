import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../utils/AppColors.dart';
import '../utils/AppWidget.dart';

class MainScreen extends StatefulWidget {
  static String tag = '/MainScreen';

  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int currentIndex1 = 0;
  final example1 = [
    'Example 1',
    'Reels',
    'New Photo',
    'Activity',
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    afterBuildCreated(() {
      changeStatusColor(appStore.scaffoldBackground!);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        appBar: appBar(
          context,
          'Main Screen',
          iconColor: Theme.of(context).iconTheme.color,
          showBack: false,
          actions: [
            Tooltip(
              message: 'Dark Mode',
              child: Switch(
                value: appStore.isDarkModeOn,
                activeColor: appColorPrimary,
                onChanged: (s) {
                  appStore.toggleDarkMode(value: s);
                  setState(() {});
                },
              ),
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: Text(example1.elementAt(currentIndex1),
                      style: TextStyle(color: appStore.textPrimaryColor, fontSize: 24)
                  )
              ),
              15.height,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bulletText('A bottom navigation bar is usually used in conjunction with a Scaffold.'),
                  5.height,
                  bulletText('Bottom navigation bar consists of multiple items in the form of text labels, icons, or both.'),
                  5.height,
                  bulletText('This example consists of icons and label both.'),
                  5.height,
                  bulletText('Bottom Navigation type is Fixed (Default Type).'),
                  5.height,
                  bulletText('Use when there are less than five items .'),
                ],
              )
            ],
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
          selectedItemColor: appStore.iconColor,
          unselectedItemColor: appStore.textSecondaryColor,
          backgroundColor: appStore.appBarColor,
          items: [
            //1
            BottomNavigationBarItem(
              icon: Image.asset(
                  'images/widgets/materialWidgets/mwAppStructureWidgets/BottomNavigation/home.png',
                  height: 25,
                  width: 25,
                  color: appStore.iconSecondaryColor),
              activeIcon: Image.asset(
                  'images/widgets/materialWidgets/mwAppStructureWidgets/BottomNavigation/home_fill.png',
                  height: 25,
                  width: 25,
                  color: appStore.iconColor),
              label: 'Home',
              backgroundColor: appStore.appBarColor,
            ),
            //2
            BottomNavigationBarItem(
              icon: Image.asset(
                  'images/widgets/materialWidgets/mwAppStructureWidgets/BottomNavigation/reel.png',
                  height: 25,
                  width: 25,
                  color: appStore.iconSecondaryColor),
              activeIcon: Image.asset(
                  'images/widgets/materialWidgets/mwAppStructureWidgets/BottomNavigation/reel_fill.png',
                  height: 25,
                  width: 25,
                  color: appStore.iconColor),
              label: 'Reels',
            ),
            //3
            BottomNavigationBarItem(
              icon: Image.asset(
                  'images/widgets/materialWidgets/mwAppStructureWidgets/BottomNavigation/gallery.png',
                  height: 25,
                  width: 25,
                  color: appStore.iconSecondaryColor),
              activeIcon: Image.asset(
                  'images/widgets/materialWidgets/mwAppStructureWidgets/BottomNavigation/gallery_fill.png',
                  height: 25,
                  width: 25,
                  color: appStore.iconColor),
              label: 'Gallery',
            ),
            //4
            BottomNavigationBarItem(
              icon: Image.asset(
                  'images/widgets/materialWidgets/mwAppStructureWidgets/BottomNavigation/heart.png',
                  height: 25,
                  width: 25,
                  color: appStore.iconSecondaryColor),
              activeIcon: Image.asset(
                  'images/widgets/materialWidgets/mwAppStructureWidgets/BottomNavigation/heart_fill.png',
                  height: 25,
                  width: 25,
                  color: appStore.iconColor),
              label: 'Activity',
            ),
          ],
        ),
      ),
    );
  }
}

Widget bulletText(String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text("•  ",
          style: TextStyle(color: appStore.textPrimaryColor, fontSize: 14)),
      Text(text,
              style: TextStyle(color: appStore.textPrimaryColor, fontSize: 14))
          .expand(),
    ],
  );
}
