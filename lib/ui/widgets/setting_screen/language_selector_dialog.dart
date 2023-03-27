import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../bloc/locale/locale_cubit.dart';
import '../../../core/constants/locale_key.dart';
import '../../../core/enums/locale_enum.dart';
import '../../../core/helpers/enum_helper.dart';
import '../app_dialog.dart';

class LanguageSelectorDialog extends StatelessWidget {
  const LanguageSelectorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: tr(LocaleKey.selectALanguage),
      children: EnumHelper.getLocales()
          .map(
            (locale) => Card(
              margin: const EdgeInsets.all(0.0),
              elevation: 0.0,
              child: InkWell(
                child: SizedBox(
                  height: 60.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        CountryFlags.flag(
                          EnumHelper.getCountryCode(
                              EnumHelper.getLocaleType(locale)),
                          height: 24.0,
                          width: 31.0,
                          borderRadius: 4.0,
                        ),
                        const SizedBox(width: 16.0),
                        Text(
                          tr(locale.languageCode),
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  finish(context);
                  LocaleEnum localeType = EnumHelper.getLocaleType(locale);
                  context.setLocale(locale);
                  BlocProvider.of<LocaleCubit>(context)
                      .changeLocale(localeType);
                },
              ),
            ),
          )
          .toList(),
    );
  }
}
