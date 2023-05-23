import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../bloc/locale/locale_cubit.dart';
import '../../../utils/constants/locale_key.dart';
import '../../../utils/enums/locale_enum.dart';
import '../../../utils/helpers/enum_helper.dart';
import '../../widgets/app_dialog.dart';

class LanguageSelectorDialog extends StatelessWidget {
  const LanguageSelectorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: tr(LocaleKey.selectALanguage),
      children: EnumHelper.getLocales()
          .map(
            (locale) => Card(
              margin: EdgeInsets.zero,
              elevation: 0.0,
              child: InkWell(
                onTap: () {
                  finish(context);
                  LocaleEnum localeType = EnumHelper.getLocaleType(locale);
                  context.setLocale(locale);
                  BlocProvider.of<LocaleCubit>(context)
                      .changeLocale(localeType);
                },
                child: SizedBox(
                  height: 60.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        CountryFlag.fromCountryCode(
                          EnumHelper.getCountryCode(
                              EnumHelper.getLocaleType(locale)),
                          height: 24.0,
                          width: 31.0,
                          borderRadius: 4.0,
                        ),
                        const SizedBox(width: 16.0),
                        Text(
                          tr(locale.languageCode),
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
