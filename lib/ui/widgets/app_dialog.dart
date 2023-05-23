import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    this.showCloseButton = true,
    this.title,
    required this.children,
  });

  final bool showCloseButton;
  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: context.cardColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showCloseButton) ...[
              GestureDetector(
                child: Container(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.close),
                ),
                onTap: () {
                  finish(context);
                },
              ),
            ],
            if (!title.isEmptyOrNull) ...[
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                child: Text(
                  title.toString(),
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              16.height,
            ],
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: children,
                ),
              ),
            ),
            8.height,
          ],
        ),
      ),
    );
  }
}
