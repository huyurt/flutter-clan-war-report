import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/widgets/bottom_navigation_bar/bottom_navigation_bar_cubit.dart';
import '../../../../utils/constants/locale_key.dart';
import '../../../../utils/enums/screen_enum.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<BottomNavigationBarCubit>().state.index;
    return Stack(
      children: [
        Card(
          margin: EdgeInsets.zero,
          elevation: 0.0,
          shadowColor: Theme.of(context).colorScheme.shadow,
          color: Theme.of(context).colorScheme.surfaceVariant,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(bottom: 4.0),
                  decoration: BoxDecoration(
                    color: currentIndex == 0
                        ? Theme.of(context).indicatorColor
                        : null,
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
                    child: Icon(AkarIcons.double_sword),
                  ),
                ),
                label: tr(LocaleKey.wars),
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(bottom: 4.0),
                  decoration: BoxDecoration(
                    color: currentIndex == 1
                        ? Theme.of(context).indicatorColor
                        : null,
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
                    child: Icon(AkarIcons.shield),
                  ),
                ),
                label: tr(LocaleKey.clans),
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(bottom: 4.0),
                  decoration: BoxDecoration(
                    color: currentIndex == 2
                        ? Theme.of(context).indicatorColor
                        : null,
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
                    child: Icon(AkarIcons.people_multiple),
                  ),
                ),
                label: tr(LocaleKey.players),
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(bottom: 4.0),
                  decoration: BoxDecoration(
                    color: currentIndex == 3
                        ? Theme.of(context).indicatorColor
                        : null,
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
                    child: Icon(AkarIcons.gear),
                  ),
                ),
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
