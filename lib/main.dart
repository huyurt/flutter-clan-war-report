import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:clan_war_report/utils/helpers/enum_helper.dart';
import 'package:clan_war_report/utils/injection.dart' as locator;
import 'package:clan_war_report/utils/routes.dart';
import 'package:clan_war_report/utils/themes/app_themes.dart';

import 'bloc/app_bloc_observer.dart';
import 'bloc/app_bloc_provider.dart';
import 'bloc/app_bloc_repository_provider.dart';
import 'bloc/settings/locale_cubit.dart';
import 'bloc/settings/theme_cubit.dart';
import 'utils/constants/locale_key.dart';
import 'utils/enums/locale_enum.dart';
import 'utils/helpers/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await EasyLocalization.ensureInitialized();
  await CacheHelper.init();
  final settings = CacheHelper.getCachedSettings();
  if (Platform.isAndroid) {
    await FlutterDisplayMode.setHighRefreshRate();
  }
  Bloc.observer = const AppBlocObserver();
  locator.init();
  //_initHomeWidget(settings);

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: EnumHelper.getLocales(),
      fallbackLocale: Locale(LocaleEnum.en.name),
      useFallbackTranslations: true,
      child: MultiRepositoryProvider(
        providers: getBlocRepositoryProviders(),
        child: MultiBlocProvider(
          providers: getBlocProviders(),
          child: const App(),
        ),
      ),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void didChangeDependencies() {
    //if (context.watch<SettingsCubit>().state.widgetRefresh) {
    //  _startBackgroundUpdate();
    //} else {
    //  _stopBackgroundUpdate();
    //}
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
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
    );
  }
}
