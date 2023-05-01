import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../utils/constants/locale_key.dart';
import '../../utils/helpers/enum_helper.dart';
import '../widgets/first_screen/theme_card.dart';
import '../widgets/setting_screen/language_selector_dialog.dart';
import '../widgets/setting_screen/text_divider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        key: PageStorageKey(key),
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        children: [
          TextDivider(text: tr(LocaleKey.language)),
          Card(
            elevation: 2,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: InkWell(
              borderRadius: const BorderRadius.all(
                Radius.circular(12),
              ),
              child: Container(
                height: 60.0,
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                child: Row(
                  children: [
                    CountryFlags.flag(
                      EnumHelper.getCountryCode(
                          EnumHelper.getLocaleType(context.locale)),
                      height: 24.0,
                      width: 31.0,
                      borderRadius: 4.0,
                    ),
                    const SizedBox(width: 16.0),
                    Text(
                      tr(context.locale.languageCode),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .apply(fontWeightDelta: 2),
                    ),
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
          Row(
            children: const [
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
          const SizedBox(height: 36),
        ],
      ),
    );
  }
}
