import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class TextDivider extends StatelessWidget {
  const TextDivider({
    super.key,
    this.text,
  });

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 16, right: 24, bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(.4),
            ),
          ),
          Visibility(
            visible: !text.isEmptyOrNull,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                tr(text ?? ''),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(.4),
            ),
          ),
        ],
      ),
    );
  }
}
