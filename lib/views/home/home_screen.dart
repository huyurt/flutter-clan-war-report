import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/utils/enums/language-type-enum.dart';
import 'package:provider/provider.dart';

import '../../utils/localization/app_localizations.dart';
import '../../utils/localization/language_provider.dart';
import '../../utils/theme/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final items = [
    {
      'title': 'What is Lorem Ipsum?',
      'description': 'Lorem Ipsum is simply dummy text.',
      'image': 'https://picsum.photos/200'
    }
  ];

  @override
  void initState() {
    context.read<ThemeProvider>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (_, themeProviderRef, __) {
      return Consumer<LanguageProvider>(builder: (_, languageProviderRef, __) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: const Padding(
              padding: EdgeInsets.all(12.0),
              child: FlutterLogo(
                style: FlutterLogoStyle.markOnly,
              ),
            ),
            actions: <Widget>[
              Tooltip(
                message: 'Dark Mode',
                child: Switch(
                  value: themeProviderRef.isDarkModeOn,
                  onChanged: (s) {
                    LanguageTypeEnum languageType =
                        s ? LanguageTypeEnum.tr : LanguageTypeEnum.en;
                    AppLocalizations.of(context)
                        .loadWithLocale(Locale(languageType.name))
                        .then((value) {
                      languageProviderRef.changeLanguage(languageType);
                    });
                    themeProviderRef.changeTheme(s);
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(AppLocalizations.of(context).translate('title')),
                  subtitle: Text(items[index]['description'] ?? ''),
                  leading: Image.network(items[index]['image'] ?? ''),
                ),
              );
            },
          ),
        );
      });
    });
  }
}
