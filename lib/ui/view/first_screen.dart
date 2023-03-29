import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:more_useful_clash_of_clans/utils/constants/locale_key.dart';

import '../../bloc/locale/locale_cubit.dart';
import '../../utils/enums/locale_enum.dart';
import '../widgets/first_screen/theme_card.dart';
import '../widgets/header.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: [
          const Header(text: 'app_name'),
          Card(
            elevation: 2,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: SwitchListTile(
              onChanged: (bool newValue) {
                LocaleEnum localType = newValue ? LocaleEnum.tr : LocaleEnum.en;
                context.setLocale(Locale(localType.name));
                BlocProvider.of<LocaleCubit>(context).changeLocale(localType);
              },
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              value: context.locale == Locale(LocaleEnum.tr.name),
              title: Row(
                children: [
                  const Icon(Ionicons.language_outline),
                  const SizedBox(width: 16),
                  Text(
                    tr(LocaleKey.language),
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
        ],
      ),
    );
  }
}
