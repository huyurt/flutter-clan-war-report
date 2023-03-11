import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/localization_provider.dart';
import '../../utils/constants/localization.dart';
import '../../utils/localization/app_localizations.dart';

class WarsScreen extends StatefulWidget {
  const WarsScreen({super.key});

  @override
  State<WarsScreen> createState() => _WarsScreenState();
}

class _WarsScreenState extends State<WarsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (_, localizationProviderRef, __) {
        return Text(
          AppLocalizations.of(context).translate(Localization.Screen),
        );
      },
    );
  }
}
