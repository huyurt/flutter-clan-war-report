import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key, required this.title, this.actions});

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(tr(title)),
      surfaceTintColor: Colors.red,
      actions: [
        ...?actions,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
