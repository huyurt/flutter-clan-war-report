import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/utils/enums/localization_enum.dart';
import 'package:more_useful_clash_of_clans/utils/localization/app_localizations.dart';
import 'package:more_useful_clash_of_clans/utils/theme/app_themes.dart';
import 'package:more_useful_clash_of_clans/providers/theme_provider.dart';
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
          supportedLocales: [
            Locale(LocalizationEnum.en.name),
            Locale(LocalizationEnum.tr.name),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
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
