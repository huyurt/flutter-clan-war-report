import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:more_useful_clash_of_clans/ui/widgets/header.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/constants/localization.dart';
import '../../utils/enums/localization_enum.dart';
import '../widgets/first_screen/theme_card.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            ElevatedButton(
              child: const Icon(Icons.arrow_back),
              onPressed: () {
                finish(context);
              },
            ),
            const Header(text: Localization.settings),
            Card(
              elevation: 2,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: SwitchListTile(
                onChanged: (bool newValue) {
                  context.setLocale(newValue
                      ? Locale(LocalizationEnum.tr.name)
                      : Locale(LocalizationEnum.en.name));
                },
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                value: context.locale == Locale(LocalizationEnum.tr.name),
                title: Row(
                  children: <Widget>[
                    const Icon(Ionicons.language_outline),
                    const SizedBox(width: 16),
                    Text(
                      tr(Localization.language),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .apply(fontWeightDelta: 2),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.75 / 1,
              padding: EdgeInsets.zero,
              children: const <ThemeCard>[
                ThemeCard(
                  mode: ThemeMode.system,
                  icon: Ionicons.contrast_outline,
                ),
                ThemeCard(
                  mode: ThemeMode.light,
                  icon: Ionicons.sunny_outline,
                ),
                ThemeCard(
                  mode: ThemeMode.dark,
                  icon: Ionicons.moon_outline,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
