import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:more_useful_clash_of_clans/component/ThemeItemWidget.dart';
import 'package:more_useful_clash_of_clans/model/AppModel.dart';

class ThemeList extends StatelessWidget {
  final List<ProTheme> list;

  const ThemeList(this.list, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedListView(
      scrollDirection: Axis.vertical,
      itemCount: list.length,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      listAnimationType: ListAnimationType.FadeIn,
      fadeInConfiguration: FadeInConfiguration(delay: 100.milliseconds, duration: 700.milliseconds),
      itemBuilder: (context, index) => ThemeItemWidget(index, list[index]),
    );
  }
}
