import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:more_useful_clash_of_clans/core/enums/locale_enum.dart';

import '../../core/helpers/cache_helper.dart';
import '../../core/helpers/enum_helper.dart';

class LocaleCubit extends Cubit<Locale?> {
  LocaleCubit() : super(EnumHelper.getLocale(CacheHelper.getCachedLocale()));

  void getCachedLocale() {
    final cachedLocaleType = CacheHelper.getCachedLocale();
    if (cachedLocaleType == null) {
      emit(null);
    }
    emit(Locale(cachedLocaleType!.name));
  }

  Future<void> changeLocale(LocaleEnum localeType) async {
    await CacheHelper.setCachedLocale(localeType);
    emit(Locale(localeType.name));
  }
}
