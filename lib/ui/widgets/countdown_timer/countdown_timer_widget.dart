import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

import '../../../utils/constants/locale_key.dart';

class CountdownTimerWidget extends StatefulWidget {
  const CountdownTimerWidget({super.key, required this.remainingDateTime});

  final DateTime remainingDateTime;

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late CountdownTimerController controller;

  @override
  void initState() {
    super.initState();
    controller = CountdownTimerController(
        endTime: widget.remainingDateTime.millisecondsSinceEpoch);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CountdownTimer(
      controller: controller,
      widgetBuilder: (BuildContext context, CurrentRemainingTime? time) {
        if (time == null) {
          return const Text('');
        }
        List<Widget> list = [];
        if (time.hours != null) {
          if (time.min != 0) {
            list.add(
              Row(
                children: [
                  Text(
                      '${time.hours}${tr(LocaleKey.hourShort)} ${time.min}${tr(LocaleKey.minuteShort)}'),
                ],
              ),
            );
          } else {
            list.add(
              Row(
                children: [
                  Text('${time.hours}${tr(LocaleKey.hourShort)}'),
                ],
              ),
            );
          }
        } else if (time.min != null) {
          list.add(
            Row(
              children: [
                Text(
                    '${time.min}${tr(LocaleKey.minuteShort)} ${time.sec}${tr(LocaleKey.secondShort)}'),
              ],
            ),
          );
        } else if (time.sec != null) {
          list.add(
            Row(
              children: [
                Text('${time.sec}${tr(LocaleKey.secondShort)}'),
              ],
            ),
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: list,
        );
      },
    );
  }
}
