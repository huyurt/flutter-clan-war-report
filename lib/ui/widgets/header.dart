import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.text, this.actions});

  final String text;
  final List<Widget>? actions;

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
        Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: 5,
          runSpacing: 5,
          children: [
            ...?actions,
          ],
        ),
      ],
    );
  }
}
