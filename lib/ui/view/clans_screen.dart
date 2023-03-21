import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/core/constants/locale_keys.dart';

class ClansScreen extends StatefulWidget {
  const ClansScreen({super.key});

  @override
  State<ClansScreen> createState() => _ClansScreenState();
}

class _ClansScreenState extends State<ClansScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: [
          Text(tr(LocaleKey.clans)),
        ],
      ),
    );
  }
}
