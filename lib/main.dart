import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:more_useful_clash_of_clans/routes.dart';
import 'package:more_useful_clash_of_clans/states/theme_mode_state.dart';
import 'package:more_useful_clash_of_clans/utils/constants/app_constants.dart';
import 'package:more_useful_clash_of_clans/utils/enums/localization_enum.dart';
import 'package:more_useful_clash_of_clans/utils/theme/app_themes.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  if (Platform.isAndroid) {
    await FlutterDisplayMode.setHighRefreshRate();
  }
  final Directory tmpDir = await getTemporaryDirectory();
  await Hive.initFlutter(tmpDir.toString());
  await Hive.openBox(AppConstants.hivePreferenceKey);

  runApp(
    ProviderScope(
      child: EasyLocalization(
        path: 'assets/translations',
        supportedLocales: <Locale>[
          Locale(LocalizationEnum.en.name),
          Locale(LocalizationEnum.tr.name),
        ],
        fallbackLocale: Locale(LocalizationEnum.en.name),
        useFallbackTranslations: true,
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeModeState currentTheme = ref.watch(themeProvider);

    return MaterialApp(
      title: 'More Useful Clash of Clans',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: currentTheme.themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      //home: const SkeletonScreen(),
      initialRoute: Routes.splash,
      routes: Routes.routes,
    );
  }
}
