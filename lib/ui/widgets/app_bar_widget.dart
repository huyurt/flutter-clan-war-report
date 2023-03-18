import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key, required this.title, this.actions});

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).colorScheme.brightness;

    return AppBar(
      title: Text(tr(title)),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: brightness,
        systemStatusBarContrastEnforced: false,
        statusBarColor: Theme.of(context).colorScheme.background,
        statusBarIconBrightness:
            brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      ),
      backgroundColor: Colors.transparent,
      excludeHeaderSemantics: true,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      actions: [
        ...?actions,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
