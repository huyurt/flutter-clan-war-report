import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:more_useful_clash_of_clans/routes.dart';
import 'package:more_useful_clash_of_clans/utils/AppDataProvider.dart';
import 'package:more_useful_clash_of_clans/utils/locale/Languages.dart';
import 'package:more_useful_clash_of_clans/utils/theme/manager/ThemeManager.dart';
import 'package:more_useful_clash_of_clans/view/HomeScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

BaseLanguage? language;

void main() async {
  //region Entry Point
  WidgetsFlutterBinding.ensureInitialized();

  var prefs = await SharedPreferences.getInstance();
  int? initTheme = prefs.getInt(THEME_MODE_INDEX);
  if (initTheme != null) {
    ThemeManager.instance.changeTheme(ThemeEnum.values[initTheme]);
  }

  await initialize(aLocaleLanguageList: languageList());

  defaultRadius = 10;

  defaultToastGravityGlobal = ToastGravity.BOTTOM;

  if (isMobile || isWeb) {
    Firebase.initializeApp().then((value) {
      // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    });
  }

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager.instance),
      ],
      child: const MyApp()
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: context.appTheme,
      initialRoute: HomeScreen.tag,
      routes: routes(),
      navigatorKey: navigatorKey,
      scrollBehavior: SBehavior(),
      supportedLocales: LanguageDataModel.languageLocales(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      localeResolutionCallback: (locale, supportedLocales) => locale,
      locale: const Locale('tr'), //appStore.selectedLanguageCode),
    );
  }
}
