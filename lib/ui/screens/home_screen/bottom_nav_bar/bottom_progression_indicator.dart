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
    return const LinearProgressIndicator(
      backgroundColor: Colors.amberAccent,
      valueColor: AlwaysStoppedAnimation(Colors.amber),
      minHeight: 2.0,
    );
  }
}
