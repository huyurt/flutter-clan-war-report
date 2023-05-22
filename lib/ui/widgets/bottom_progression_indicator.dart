import 'package:flutter/material.dart';

class BottomProgressionIndicator extends StatefulWidget {
  const BottomProgressionIndicator({Key? key}) : super(key: key);

  @override
  State<BottomProgressionIndicator> createState() =>
      _BottomProgressionIndicatorState();
}

class _BottomProgressionIndicatorState
    extends State<BottomProgressionIndicator> {
  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: Colors.white70,
      valueColor: AlwaysStoppedAnimation(Theme.of(context).indicatorColor),
      minHeight: 3.0,
    );
  }
}
