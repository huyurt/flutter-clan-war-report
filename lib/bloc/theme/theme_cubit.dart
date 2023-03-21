import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/core/enums/theme_enum.dart';
import 'package:more_useful_clash_of_clans/core/helpers/enum_helper.dart';

import '../../core/helpers/cache_helper.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(EnumHelper.getThemeMode(CacheHelper.getCachedTheme()));

  void getCachedTheme() {
    final cachedThemeType = CacheHelper.getCachedTheme();
    ThemeMode themeMode = EnumHelper.getThemeMode(cachedThemeType);
    emit(themeMode);
  }

  Future<void> changeTheme(ThemeMode themeMode) async {
    ThemeEnum themeType = EnumHelper.getThemeType(themeMode);
    await CacheHelper.setCachedTheme(themeType);
    emit(themeMode);
  }
}
