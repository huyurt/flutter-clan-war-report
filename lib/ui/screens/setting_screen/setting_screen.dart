import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:in_app_review/in_app_review.dart';
import 'package:ionicons/ionicons.dart';
import 'package:clan_war_report/models/app/settings_model.dart';
import 'package:clan_war_report/ui/screens/setting_screen/about_app_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../bloc/settings/settings_cubit.dart';
import '../../../utils/constants/locale_key.dart';
import '../../../utils/helpers/enum_helper.dart';
import 'theme_card.dart';
import 'language_selector_dialog.dart';
import '../../widgets/text_divider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsModel settings = context.watch<SettingsCubit>().state;

    //final inAppReview = InAppReview.instance;

    return Material(
      child: Column(
        children: [
          AppBar(
            title: Text(tr(LocaleKey.settings)),
          ),
          Expanded(
            child: ListView(
              key: PageStorageKey(key),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              children: [
                const TextDivider(text: LocaleKey.language),
                Card(
                  elevation: 2,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    child: Container(
                      height: 60.0,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: CountryFlag.fromCountryCode(
                              EnumHelper.getCountryCode(
                                  EnumHelper.getLocaleType(context.locale)),
                              height: 24.0,
                              width: 31.0,
                              borderRadius: 4.0,
                            ),
                          ),
                          Text(tr(context.locale.languageCode)),
                        ],
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            const LanguageSelectorDialog(),
                      );
                    },
                  ),
                ),
                TextDivider(text: tr(LocaleKey.theme)),
                const Row(
                  children: [
                    ThemeCard(
                      themeMode: ThemeMode.system,
                      icon: Ionicons.contrast_outline,
                    ),
                    ThemeCard(
                      themeMode: ThemeMode.light,
                      icon: Ionicons.sunny_outline,
                    ),
                    ThemeCard(
                      themeMode: ThemeMode.dark,
                      icon: Ionicons.moon_outline,
                    ),
                  ],
                ),
                const TextDivider(),
                /*
                Card(
                  elevation: 2,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    child: Container(
                      height: 60.0,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 12.0),
                            child: Icon(Icons.star),
                          ),
                          Text(tr(LocaleKey.rateOnGooglePlay)),
                        ],
                      ),
                    ),
                    onTap: () async {
                      if (await inAppReview.isAvailable()) {
                        inAppReview.requestReview();
                      }
                    },
                  ),
                ),
                */
                Card(
                  elevation: 2,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    child: Container(
                      height: 60.0,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 12.0),
                            child: Icon(Icons.info),
                          ),
                          Text(tr(LocaleKey.aboutApp)),
                        ],
                      ),
                    ),
                    onTap: () {
                      const AboutAppScreen().launch(context);
                    },
                  ),
                ),
                /*
                TextDivider(text: tr(LocaleKey.widget)),
                Card(
                  elevation: 2,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(tr(LocaleKey.widgetRefresh)),
                            ),
                            Text(
                              tr(LocaleKey.widgetRefreshMessage),
                              style:
                                  const TextStyle(color: Colors.grey, fontSize: 10.0),
                            ),
                          ],
                        ),
                        trailing: CupertinoSwitch(
                            value: settings.widgetRefresh,
                            activeColor: Colors.amber,
                            onChanged: (bool newValue) =>
                                BlocProvider.of<SettingsCubit>(context)
                                    .changeWidgetRefresh(newValue)),
                      ),
                    ),
                  ),
                ),
                */
                const SizedBox(height: 24.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
