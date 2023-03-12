import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/ui/screens/setting_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/constants/localization.dart';
import '../widgets/header.dart';

class WarsScreen extends StatelessWidget {
  const WarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          Header(
            text: Localization.wars,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  const SettingScreen().launch(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
