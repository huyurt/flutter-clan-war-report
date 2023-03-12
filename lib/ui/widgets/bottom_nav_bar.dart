import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';

import '../../states/widgets/bottom_nav_bar/bottom_nav_bar_state.dart';
import '../../utils/constants/localization.dart';
import '../../utils/enums/screen_enum.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ScreenEnum? navScreen = ref.watch(bottomNavProvider) as ScreenEnum?;

    return Card(
      margin: const EdgeInsets.only(top: 1, right: 4, left: 4),
      elevation: 4,
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: Theme.of(context).colorScheme.surfaceVariant,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: navScreen?.index ?? 0,
        onTap: (int index) {
          ref
              .read(bottomNavProvider.notifier)
              .setAndPersistValue(ScreenEnum.values[index]);
        },
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).textTheme.bodySmall!.color,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Ionicons.home_outline),
            label: tr(Localization.wars),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Ionicons.information_circle_outline),
            label: tr(Localization.clans),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Ionicons.planet),
            label: tr(Localization.players),
          ),
        ],
      ),
    );
  }
}
