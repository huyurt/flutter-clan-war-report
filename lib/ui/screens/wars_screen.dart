import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/constants/localization.dart';

class WarsScreen extends ConsumerStatefulWidget {
  const WarsScreen({super.key});

  @override
  ConsumerState<WarsScreen> createState() => _WarsScreenState();
}

class _WarsScreenState extends ConsumerState<WarsScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          Text(
            tr(Localization.wars),
          )
        ],
      ),
    );
  }
}
