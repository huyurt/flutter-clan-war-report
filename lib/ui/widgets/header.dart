import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          tr(text),
          textAlign: TextAlign.start,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .apply(fontWeightDelta: 2),
        ),
      ],
    );
  }
}
