import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/utils/enums/language-type.dart';
import 'package:more_useful_clash_of_clans/utils/localization/app_localizations.dart';
import 'package:more_useful_clash_of_clans/utils/theme/app_themes.dart';
import 'package:more_useful_clash_of_clans/utils/theme/theme_provider.dart';
import 'package:more_useful_clash_of_clans/routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  final Locale locale;

  const MyApp({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, themeProviderRef, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: locale,
          //List of all supported locales
          supportedLocales: [
            Locale(LanguageType.en.name),
            Locale(LanguageType.tr.name),
          ],
          //These delegates make sure that the localization data for the proper language is loaded
          localizationsDelegates: const [
            //A class which loads the translations from JSON files
            AppLocalizations.delegate,
            //Built-in localization of basic text for Material widgets (means those default Material widget such as alert dialog icon text)
            GlobalMaterialLocalizations.delegate,
            //Built-in localization for text direction LTR/RTL
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          title: 'More Useful Clash of Clans',
          initialRoute: Routes.splash,
          routes: Routes.routes,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode:
              themeProviderRef.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
        );
      },
    );
  }
}
