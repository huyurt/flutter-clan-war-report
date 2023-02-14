import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:more_useful_clash_of_clans/routes.dart';
import 'package:more_useful_clash_of_clans/store/AppStore.dart';
import 'package:more_useful_clash_of_clans/utils/AppConstant.dart';
import 'package:more_useful_clash_of_clans/utils/AppDataProvider.dart';
import 'package:more_useful_clash_of_clans/utils/AppTheme.dart';
import 'package:more_useful_clash_of_clans/utils/flutter_web_frame/flutter_web_frame.dart';
import 'package:more_useful_clash_of_clans/view/MainScreen.dart';
import 'package:nb_utils/nb_utils.dart';

import 'locale/AppLocalizations.dart';
import 'locale/Languages.dart';

AppStore appStore = AppStore();

BaseLanguage? language;

void main() async {
  //region Entry Point
  WidgetsFlutterBinding.ensureInitialized();

  await initialize(aLocaleLanguageList: languageList());

  appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));
  await appStore.setLanguage(
      getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: defaultLanguage));

  defaultRadius = 10;

  defaultToastGravityGlobal = ToastGravity.BOTTOM;

  if (isMobile || isWeb) {
    Firebase.initializeApp().then((value) {
      // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => FlutterWebFrame(
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: '$mainAppName${!isMobile ? ' ${platformName()}' : ''}',
            theme: !appStore.isDarkModeOn ? AppThemeData.lightTheme : AppThemeData.darkTheme,
            initialRoute: MainScreen.tag,
            routes: routes(),
            onGenerateInitialRoutes: (route) => [
              MaterialPageRoute(builder: (_) => const MainScreen()),
            ],
            navigatorKey: navigatorKey,
            scrollBehavior: SBehavior(),
            supportedLocales: LanguageDataModel.languageLocales(),
            localizationsDelegates: const [
              AppLocalizations(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            localeResolutionCallback: (locale, supportedLocales) => locale,
            locale: Locale(appStore.selectedLanguageCode),
          );
        },
        maximumSize: const Size(475.0, 812.0),
        enabled: kIsWeb,
      ),
    );
  }
}
