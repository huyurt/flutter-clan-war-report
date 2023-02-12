import 'package:more_useful_clash_of_clans/model/AppModel.dart';
import 'package:nb_utils/nb_utils.dart';

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(id: 1, name: 'English', languageCode: 'en', fullLanguageCode: 'en-US', flag: 'images/flag/ic_us.png'),
    LanguageDataModel(id: 1, name: 'Turkish', languageCode: 'tr', fullLanguageCode: 'tr-TR', flag: 'images/flag/ic_tr.png'),
  ];
}

Future<AppTheme> getAllAppsAndThemes() async {
  AppTheme appTheme = AppTheme();

  return appTheme;
}
