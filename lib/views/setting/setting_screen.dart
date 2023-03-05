import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:more_useful_clash_of_clans/utils/localization/app_localizations.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/constants/app_constants.dart';
import '../../utils/constants/localization.dart';
import '../../utils/enums/language-type-enum.dart';
import '../../utils/localization/language_provider.dart';
import 'setting-screen-components.dart';
import '../../utils/theme/theme_provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (_, languageProviderRef, __) {
        return Consumer<ThemeProvider>(
          builder: (_, themeProviderRef, __) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    finish(context);
                  },
                  icon: Icon(Icons.arrow_back,
                      color: themeProviderRef.isDarkModeOn ? white : black),
                ),
                title: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: Row(
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context)
                            .translate(Localization.Settings),
                        maxLines: 1,
                      ).expand(),
                    ],
                  ),
                ),
              ),
              body: FutureBuilder(
                future: languageProviderRef.appLocale,
                builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                  if (asyncSnapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Stack(
                      alignment: Alignment.center,
                      fit: StackFit.expand,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              16.height,
                              Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: [
                                  SettingContainerWidget(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset('images/app/ic_theme.png',
                                            height: 40),
                                        Text(AppLocalizations.of(context)
                                            .translate(Localization.Theme)),
                                        Transform.scale(
                                          scale: 1.3,
                                          child: Switch(
                                            value:
                                                themeProviderRef.isDarkModeOn,
                                            onChanged: (s) {
                                              themeProviderRef
                                                  .toggleDarkMode(s);
                                              setState(() {});
                                            },
                                            //activeColor: appColorPrimary,
                                          ),
                                        )
                                      ],
                                    ),
                                  ).onTap(() {
                                    themeProviderRef.toggleDarkMode(
                                        !themeProviderRef.isDarkModeOn);
                                  }, borderRadius: radius(defaultRadius)),
                                  SettingContainerWidget(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                            'images/app/ic_documentation.png',
                                            height: 30,
                                            width: 30),
                                        8.height,
                                        const Text('Documentation'),
                                        8.height,
                                        Text('Setup Configuration',
                                            style: secondaryTextStyle(size: 12))
                                      ],
                                    ),
                                  ).onTap(() {},
                                      borderRadius: radius(defaultRadius)),
                                  SettingContainerWidget(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                            'images/app/ic_change_log.png',
                                            height: 30,
                                            width: 30),
                                        8.height,
                                        const Text('Change Log'),
                                        8.height,
                                        Text('Version History',
                                            style: secondaryTextStyle(size: 12))
                                      ],
                                    ),
                                  ).onTap(() {},
                                      borderRadius: radius(defaultRadius)),
                                  SettingContainerWidget(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset('images/app/ic_share.png',
                                            height: 30, width: 30),
                                        8.height,
                                        Text(AppLocalizations.of(context)
                                            .translate(Localization.ShareApp)),
                                        8.height,
                                        Text('Share With Friends',
                                            style: secondaryTextStyle(size: 12))
                                      ],
                                    ),
                                  ).onTap(() async {
                                    getPackageInfo().then((value) async {
                                      String package =
                                          value.packageName.validate();
                                      await Share.share(
                                          'Download from Play Store\n\n\n$AppConstants.playStoreUrl$package');
                                    });
                                  }, borderRadius: radius(defaultRadius)),
                                  SettingContainerWidget(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                            'images/app/ic_rate_app.png',
                                            height: 30,
                                            width: 30),
                                        8.height,
                                        const Text('Rate Us'),
                                        8.height,
                                        Text('Rate Google Play Store',
                                            style: secondaryTextStyle(size: 12))
                                      ],
                                    ),
                                  ).onTap(() {
                                    getPackageInfo().then((value) async {
                                      String package =
                                          value.packageName.validate();
                                      launchUrl(Uri.parse(
                                          "$AppConstants.playStoreUrl$package"));
                                    });
                                  }, borderRadius: radius(defaultRadius)),
                                  SettingContainerWidget(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                            MaterialCommunityIcons
                                                .google_translate,
                                            size: 30),
                                        8.height,
                                        Text(AppLocalizations.of(context)
                                            .translate(Localization.Language)),
                                        8.height,
                                        Text('Support Language',
                                            style: secondaryTextStyle(size: 12))
                                      ],
                                    ),
                                  ).onTap(() async {
                                    Locale appLocale = asyncSnapshot.data;
                                    LanguageTypeEnum languageType =
                                        appLocale.languageCode == 'en'
                                            ? LanguageTypeEnum.tr
                                            : LanguageTypeEnum.en;
                                    AppLocalizations.of(context)
                                        .loadWithLocale(
                                            Locale(languageType.name))
                                        .then((value) {
                                      languageProviderRef
                                          .changeLanguage(languageType);
                                    });
                                  }, borderRadius: radius(defaultRadius)),
                                  SettingContainerWidget(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                          'images/app/app_ic_phone.svg',
                                          height: 30),
                                      8.height,
                                      const Text('Contact Us'),
                                      8.height,
                                      Text('Get In Touch With Us',
                                          style: secondaryTextStyle(size: 12)),
                                    ],
                                  )).onTap(() {
                                    contactBottomSheet(context);
                                  }, borderRadius: radius(defaultRadius)),
                                  SnapHelperWidget<PackageInfoData>(
                                    future: getPackageInfo(),
                                    onSuccess: (data) => SettingContainerWidget(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.info_outline,
                                              size: 30),
                                          8.height,
                                          const Text('About Us'),
                                          8.height,
                                          Row(
                                            children: [
                                              Text(
                                                  'Version ${data.versionName}',
                                                  style: secondaryTextStyle(
                                                      size: 12)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ).onTap(() {
                                      //AboutUsScreen().launch(context);
                                    }, borderRadius: radius(defaultRadius)),
                                  ),
                                ],
                              ).paddingSymmetric(horizontal: 16),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
