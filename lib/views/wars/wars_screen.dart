import 'package:flutter/material.dart';

import '../../utils/constants/localization.dart';
import '../../utils/localization/app_localizations.dart';

class WarsScreen extends StatefulWidget {
  final int currentIndex;

  const WarsScreen({super.key, required this.currentIndex});

  @override
  State<WarsScreen> createState() => _WarsScreenState();
}

class _WarsScreenState extends State<WarsScreen> {
  @override
  Widget build(BuildContext context) {
    return Text(
      '${AppLocalizations.of(context).translate(Localization.Screen)} ${widget.currentIndex + 1}',
    );
  }
}
