import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:more_useful_clash_of_clans/utils/constants/localization.dart';

class ClansScreen extends ConsumerStatefulWidget {
  const ClansScreen({super.key});

  @override
  ConsumerState<ClansScreen> createState() => _ClansScreenState();
}

class _ClansScreenState extends ConsumerState<ClansScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: [
          Text(tr(Localization.clans)),
        ],
      ),
    );
  }
}
