import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/theme/theme_cubit.dart';

class ThemeCard extends StatelessWidget {
  const ThemeCard({
    super.key,
    required this.themeMode,
    required this.icon,
  });

  final IconData icon;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    final ThemeMode currentThemeMode = context.watch<ThemeCubit>().state;
    return Expanded(
      flex: 1,
      child: Card(
        elevation: 2,
        color: currentThemeMode == themeMode
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: InkWell(
          onTap: () =>
              BlocProvider.of<ThemeCubit>(context).changeTheme(themeMode),
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Icon(icon, size: 32),
          ),
        ),
      ),
    );
  }
}
