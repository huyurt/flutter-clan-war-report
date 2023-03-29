import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../utils/constants/locale_key.dart';

class WarsScreen extends StatelessWidget {
  const WarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: [
          Text(
            tr(LocaleKey.wars),
          ),
        ],
      ),
    );
  }
}
