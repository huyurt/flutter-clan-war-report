import 'package:bloc/bloc.dart';
import 'package:more_useful_clash_of_clans/models/app/settings_model.dart';

import '../../utils/helpers/cache_helper.dart';

class SettingsCubit extends Cubit<SettingsModel> {
  SettingsCubit() : super(CacheHelper.getCachedSettings());

  Future<void> changeWidgetRefresh(bool newValue) async {
    final settings = state.copyWith(widgetRefresh: newValue);
    await CacheHelper.setCachedSettings(settings);
    emit(settings);
  }
}
