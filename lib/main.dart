import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:more_useful_clash_of_clans/repositories/bookmarked_clan_tags/bookmarked_clan_tags_cache.dart';
import 'package:more_useful_clash_of_clans/repositories/bookmarked_clan_tags/bookmarked_clan_tags_repository.dart';
import 'package:more_useful_clash_of_clans/repositories/bookmarked_player_tags/bookmarked_player_tags_cache.dart';
import 'package:more_useful_clash_of_clans/repositories/bookmarked_player_tags/bookmarked_player_tags_repository.dart';
import 'package:more_useful_clash_of_clans/repositories/search_clan/search_clan_cache.dart';
import 'package:more_useful_clash_of_clans/repositories/search_clan/search_clan_repository.dart';
import 'package:more_useful_clash_of_clans/utils/helpers/enum_helper.dart';
import 'package:more_useful_clash_of_clans/routes.dart';
import 'package:more_useful_clash_of_clans/utils/themes/app_themes.dart';

import 'bloc/app_bloc_observer.dart';
import 'bloc/locale/locale_cubit.dart';
import 'bloc/theme/theme_cubit.dart';
import 'bloc/widgets/bookmarked_clan_tags/bookmarked_clan_tags_cubit.dart';
import 'bloc/widgets/bookmarked_player_tags/bookmarked_player_tags_cubit.dart';
import 'bloc/widgets/bottom_navigation_bar/bottom_navigation_bar_cubit.dart';
import 'bloc/widgets/clan_detail/clan_detail_bloc.dart';
import 'bloc/widgets/player_detail/player_detail_bloc.dart';
import 'bloc/widgets/search_clan/search_clan_bloc.dart';
import 'utils/constants/locale_key.dart';
import 'utils/enums/locale_enum.dart';
import 'utils/helpers/cache_helper.dart';

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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => SearchClanRepository(
            cache: SearchClanCache(),
          ),
        ),
        RepositoryProvider(
          create: (context) => BookmarkedClanTagsRepository(
            cache: BookmarkedClanTagsCache(),
          ),
        ),
        RepositoryProvider(
          create: (context) => BookmarkedPlayerTagsRepository(
            cache: BookmarkedPlayerTagsCache(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => LocaleCubit(),
          ),
          BlocProvider(
            create: (_) => ThemeCubit(),
          ),
          BlocProvider(
            create: (_) => BottomNavigationBarCubit(),
          ),
          BlocProvider(
            create: (context) => SearchClanBloc(
              searchClanRepository: context.read<SearchClanRepository>(),
            ),
          ),
          BlocProvider(
            create: (_) => ClanDetailBloc(),
          ),
          BlocProvider(
            create: (_) => PlayerDetailBloc(),
          ),
          BlocProvider(
            create: (context) => BookmarkedClanTagsCubit(
              bookmarkedClanTagsRepository:
                  context.read<BookmarkedClanTagsRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => BookmarkedPlayerTagsCubit(
              bookmarkedPlayerTagsRepository:
                  context.read<BookmarkedPlayerTagsRepository>(),
            ),
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
      ),
    );
  }
}
