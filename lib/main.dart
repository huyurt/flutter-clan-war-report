import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:more_useful_clash_of_clans/utils/helpers/shared_preference_helper.dart';
import 'package:more_useful_clash_of_clans/utils/localization/language_provider.dart';
import 'package:more_useful_clash_of_clans/utils/locator.dart';
import 'package:more_useful_clash_of_clans/utils/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import 'my_app.dart';

GetIt locator = GetIt.instance;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator(locator);
  await locator.allReady();
  Locale locale = await initLanguage();
  runApp(App(
    locale: locale,
  ));
}

Future<Locale> initLanguage() async {
  String languageCode = await locator<SharedPreferenceHelper>().appLocale;
  return Locale(languageCode);
}

class App extends StatelessWidget {
  final Locale locale;

  const App({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider<LanguageProvider>(
          create: (context) => LanguageProvider(),
        ),
      ],
      child: MyApp(
        locale: locale,
      ),
    );
  }
}
