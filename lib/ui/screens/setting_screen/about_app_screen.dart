import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/locale_key.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocaleKey.aboutApp)),
      ),
      body: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final packageInfo = snapshot.data;
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    key: PageStorageKey(key),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Text(
                          packageInfo?.appName ?? '',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                      FadeIn(
                        animate: true,
                        duration: const Duration(milliseconds: 250),
                        child: Center(
                          child: Container(
                            height: 64.0,
                            width: 64.0,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Image.asset(
                              AppConstants.appIconImage,
                              height: 32.0,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Column(
                          children: [
                            Text(
                              tr(LocaleKey.aboutAppShortMessage),
                              style: const TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                            const Text(
                              AppConstants.supercellFanContentPolicyUrl,
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          '${tr(LocaleKey.version)}: ${packageInfo?.version ?? ''}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        tr(LocaleKey.poweredByFlutter),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: ExpansionTile(
                          initiallyExpanded: true,
                          title: Text(
                            tr(LocaleKey.aboutAppQuestion1),
                            style: const TextStyle(fontSize: 12.0),
                          ),
                          children: [
                            ListTile(
                              title: Text(
                                tr(LocaleKey.aboutAppAnswer1),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
