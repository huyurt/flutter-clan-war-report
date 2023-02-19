import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/utils/localization/language_provider.dart';
import 'package:more_useful_clash_of_clans/utils/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import 'my_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider<LanguageProvider>(
          create: (context) => LanguageProvider(),
        ),
      ],
      child: const MyApp(
        key: Key('MoreUsefulClashOfClans'),
      ),
    ),
  );
}
