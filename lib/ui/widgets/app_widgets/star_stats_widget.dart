import 'package:flutter/material.dart';

import '../../../models/coc/clan_league_wars_stat_model.dart';
import '../../../utils/constants/app_constants.dart';

class StarStatWidget extends StatelessWidget {
  const StarStatWidget({
    super.key,
    required this.stars,
    required this.totalStarCount,
  });

  final List<ClanLeagueWarsStats> stars;
  final int totalStarCount;

  List<Widget> getStarsWidget(int stars) {
    final zeroStar = 3 - stars;
    final widgets = <Widget>[];

    for (var index = 0; index < stars; index++) {
      widgets.add(Image.asset(
        '${AppConstants.clashResourceImagePath}${AppConstants.star3_1Image}',
        height: 16,
        fit: BoxFit.cover,
      ));
    }
    for (var index = 0; index < zeroStar; index++) {
      widgets.add(Image.asset(
        '${AppConstants.clashResourceImagePath}${AppConstants.star3_3Image}',
        height: 16,
        fit: BoxFit.cover,
      ));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        spacing: 32.0,
        children: [
          ...stars.map((star) {
            return Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.vertical,
              children: [
                Row(
                  children: [
                    ...getStarsWidget(star.stars),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.horizontal,
                    children: [
                      Text(star.totalStarCount.toString()),
                      Text(
                        ' (%${totalStarCount == 0 ? 0 : (star.totalStarCount / totalStarCount * 100).toStringAsFixed(2).padLeft(2, '0')})',
                        style: const TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
