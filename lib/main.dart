import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:more_useful_clash_of_clans/locale/AppLocalizations.dart';
import 'package:more_useful_clash_of_clans/routes.dart';
import 'package:more_useful_clash_of_clans/utils/AppConstant.dart';
import 'package:more_useful_clash_of_clans/utils/AppDataProvider.dart';
import 'package:more_useful_clash_of_clans/utils/AppTheme.dart';
import 'package:more_useful_clash_of_clans/view/AppSplashScreen.dart';
import 'package:nb_utils/nb_utils.dart';

late String darkMapStyle;
late String lightMapStyle;

void main() async {
  //region Entry Point
  WidgetsFlutterBinding.ensureInitialized();

  await initialize(aLocaleLanguageList: languageList());

  //appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));
  //await appStore.setLanguage(getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: defaultLanguage));

  darkMapStyle = await rootBundle.loadString('assets/mapStyles/dark.json');
  lightMapStyle = await rootBundle.loadString('assets/mapStyles/light.json');

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '$mainAppName${!isMobile ? ' ${platformName()}' : ''}',
      theme: AppThemeData.darkTheme,
      //!appStore.isDarkModeOn ? AppThemeData.lightTheme : AppThemeData.darkTheme,
      initialRoute: AppSplashScreen.tag,
      routes: routes(),
      onGenerateInitialRoutes: (route) =>
      [
        MaterialPageRoute(
            builder: (_) => AppSplashScreen(routeName: route.validate())),
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
      locale: const Locale('tr'),
    );
  }
}
