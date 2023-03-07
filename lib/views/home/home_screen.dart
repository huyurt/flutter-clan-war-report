import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../models/sample_list_model.dart';
import '../../utils/constants/localization.dart';
import '../../utils/localization/app_localizations.dart';
import '../../utils/localization/language_provider.dart';
import '../../utils/theme/theme_provider.dart';
import '../setting/setting_screen.dart';
import '../wars/wars_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SampleListModel> sampleData = [];
  int selectedIndex = 0;

  @override
  void initState() {
    sampleData.add(
      SampleListModel(
        title: "Home",
        launchWidget: Text("Home View", style: boldTextStyle(size: 24)),
        icon: Icons.home,
        alternateIcon: Icons.home_outlined,
      ),
    );
    sampleData.add(
      SampleListModel(
        title: "Search",
        launchWidget: Text("Search View", style: boldTextStyle(size: 24)),
        icon: Icons.search,
        alternateIcon: Icons.search,
      ),
    );
    sampleData.add(
      SampleListModel(title: ""),
    );
    sampleData.add(
      SampleListModel(
        title: "Favorite",
        launchWidget: Text("Favorite View", style: boldTextStyle(size: 24)),
        icon: Icons.favorite,
        alternateIcon: Icons.favorite_outline,
      ),
    );
    sampleData.add(
      SampleListModel(
        title: "Profile",
        launchWidget: Text("Profile View", style: boldTextStyle(size: 24)),
        icon: Icons.account_circle,
        alternateIcon: Icons.account_circle_outlined,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (_, languageProviderRef, __) {
        return Consumer<ThemeProvider>(
          builder: (_, themeProviderRef, __) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: context.scaffoldBackgroundColor,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: Icon(Icons.settings,
                        color: themeProviderRef.isDarkModeOn ? white : black),
                    onPressed: () {
                      const SettingScreen().launch(context);
                    },
                  ),
                ],
                title: Text(
                  AppLocalizations.of(context).translate(Localization.Wars),
                ),
              ),
              body: SafeArea(child: bodyContainer(selectedIndex)),
              floatingActionButton: GestureDetector(
                child: FloatingActionButton(
                  backgroundColor: context.primaryColor,
                  child: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    toast("...Klan Ekleniyor");
                    setState(() {});
                  },
                ),
                onLongPress: () {
                  toast("...Klan Ekle");
                },
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: BottomAppBar(
                clipBehavior: Clip.hardEdge,
                shape: const CircularNotchedRectangle(),
                notchMargin: 10,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ...List.generate(
                      sampleData.length,
                      (index) {
                        SampleListModel data = sampleData[index];
                        return Container(
                          child: data.title.isEmptyOrNull
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 8),
                                    ),
                                    selectedIndex == index
                                        ? Icon(data.icon, size: 24)
                                        : Icon(data.alternateIcon,
                                            size: 24, color: Colors.grey),
                                    Text(
                                      data.title.validate(),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 8),
                                    ),
                                  ],
                                ).expand()
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 8),
                                    ),
                                    selectedIndex == index
                                        ? Icon(data.icon, size: 24)
                                        : Icon(data.alternateIcon,
                                            size: 24, color: Colors.grey),
                                    Text(
                                      data.title.validate(),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 8),
                                    ),
                                  ],
                                ).onTap(() {
                                  selectedIndex = index;
                                  setState(() {});
                                }).expand(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget bodyContainer(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return WarsScreen(
          currentIndex: currentIndex,
        );
      default:
        return const Center(
          child: CircularProgressIndicator(),
        );
    }
  }
}
