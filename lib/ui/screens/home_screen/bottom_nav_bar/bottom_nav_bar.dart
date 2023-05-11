import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../bloc/widgets/bottom_navigation_bar/bottom_navigation_bar_cubit.dart';
import '../../../../utils/constants/locale_key.dart';
import '../../../../utils/enums/screen_enum.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.only(top: 2.0),
          elevation: 4,
          shadowColor: Theme.of(context).colorScheme.shadow,
          color: Theme.of(context).colorScheme.surfaceVariant,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: context.watch<BottomNavigationBarCubit>().state.index,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: Colors.transparent,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).textTheme.bodySmall!.color,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(AkarIcons.double_sword),
                label: tr(LocaleKey.wars),
              ),
              BottomNavigationBarItem(
                icon: const Icon(AkarIcons.shield),
                label: tr(LocaleKey.clans),
              ),
              BottomNavigationBarItem(
                icon: const Icon(AkarIcons.people_multiple),
                label: tr(LocaleKey.players),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Ionicons.settings_outline),
                label: tr(LocaleKey.settings),
              ),
            ],
            onTap: (int index) {
              context
                  .read<BottomNavigationBarCubit>()
                  .setScreen(ScreenEnum.values[index]);
            },
          ),
        ),
      ],
    );
  }
}
