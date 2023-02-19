import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/utils/localization/app_localizations.dart';
import 'package:more_useful_clash_of_clans/utils/localization/language_provider.dart';
import 'package:more_useful_clash_of_clans/utils/theme/app_themes.dart';
import 'package:more_useful_clash_of_clans/utils/theme/theme_provider.dart';
import 'package:more_useful_clash_of_clans/routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, themeProviderRef, __) {
        return Consumer<LanguageProvider>(
          builder: (_, languageProviderRef, __) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: languageProviderRef.appLocale,
              //List of all supported locales
              supportedLocales: const [
                Locale('en', 'US'),
                Locale('tr', 'TR'),
              ],
              //These delegates make sure that the localization data for the proper language is loaded
              localizationsDelegates: const [
                //A class which loads the translations from JSON files
                AppLocalizations.delegate,
                //Built-in localization of basic text for Material widgets (means those default Material widget such as alert dialog icon text)
                GlobalMaterialLocalizations.delegate,
                //Built-in localization for text direction LTR/RTL
                GlobalWidgetsLocalizations.delegate,
              ],
              //return a locale which will be used by the app
              localeResolutionCallback: (locale, supportedLocales) {
                //check if the current device locale is supported or not
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale?.languageCode ||
                      supportedLocale.countryCode == locale?.countryCode) {
                    return supportedLocale;
                  }
                }
                //if the locale from the mobile device is not supported yet,
                //user the first one from the list (in our case, that will be English)
                return supportedLocales.first;
              },
              title: 'More Useful Clash of Clans',
              initialRoute: Routes.splash,
              routes: Routes.routes,
              theme: AppThemes.lightTheme,
              darkTheme: AppThemes.darkTheme,
              themeMode: themeProviderRef.isDarkModeOn
                  ? ThemeMode.dark
                  : ThemeMode.light,
            );
          },
        );
      },
    );
  }
}
