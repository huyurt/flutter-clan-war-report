import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:more_useful_clash_of_clans/core/helpers/enum_helper.dart';
import 'package:more_useful_clash_of_clans/routes.dart';
import 'package:more_useful_clash_of_clans/core/themes/app_themes.dart';

import 'bloc/app_bloc_observer.dart';
import 'bloc/locale/locale_cubit.dart';
import 'bloc/theme/theme_cubit.dart';
import 'bloc/widgets/bottom_navigation_bar/bottom_navigation_bar_cubit.dart';
import 'core/constants/locale_key.dart';
import 'core/enums/locale_enum.dart';
import 'core/helpers/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await EasyLocalization.ensureInitialized();
  await CacheHelper.init();
  if (Platform.isAndroid) {
    await FlutterDisplayMode.setHighRefreshRate();
  }
  Bloc.observer = const AppBlocObserver();

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: EnumHelper.getLocales(),
      fallbackLocale: Locale(LocaleEnum.en.name),
      useFallbackTranslations: true,
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LocaleCubit(),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => BottomNavigationBarCubit(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: tr(LocaleKey.appName),
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: context.watch<ThemeCubit>().state,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.watch<LocaleCubit>().state,
            initialRoute: Routes.splash,
            routes: Routes.routes,
          );
        },
      ),
    );
  }
}
