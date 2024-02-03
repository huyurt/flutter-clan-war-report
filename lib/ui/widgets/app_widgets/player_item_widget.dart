import 'package:animate_do/animate_do.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../models/api/response/player_detail_response_model.dart';
import '../../../utils/constants/locale_key.dart';

class PlayerItemWidget extends StatelessWidget {
  const PlayerItemWidget({
    super.key,
    required this.title,
    required this.imagePath,
    required this.itemImages,
    this.itemLevels,
  });

  final String title;
  final String imagePath;
  final List<String> itemImages;
  final List<HeroEquipment>? itemLevels;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        Theme.of(context).colorScheme.brightness == Brightness.dark
            ? Colors.white24
            : Colors.black26;

    final items =
        itemLevels?.where((element) => element.village == Village.HOME).toList() ??
            <HeroEquipment>[]
                .where((element) => itemImages.contains(element.name)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: FadeIn(
            animate: true,
            duration: const Duration(milliseconds: 250),
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 4.0,
              children: itemImages.map(
                (itemImage) {
                  HeroEquipment? itemLevel = items
                      .firstWhereOrNull((element) => element.name == itemImage);
                  List<String> tooltipMessage = <String>[];
                  tooltipMessage.add(tr(itemImage));
                  tooltipMessage.add(itemLevel != null
                      ? '${tr(LocaleKey.level)} ${itemLevel.level}/${itemLevel.maxLevel}'
                      : tr(LocaleKey.notUnlocked));
                  return Padding(
                    padding: const EdgeInsets.only(right: 4.0, bottom: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 3,
                          color: borderColor,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Tooltip(
                        message: tooltipMessage
                            .getRange(0, tooltipMessage.length)
                            .join('\n'),
                        triggerMode: TooltipTriggerMode.tap,
                        preferBelow: true,
                        child: Stack(
                          children: [
                            if (itemLevel != null) ...[
                              Image.asset(
                                '$imagePath$itemImage.png',
                                height: 42.0,
                                fit: BoxFit.cover,
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.0,
                                        horizontal:
                                            (itemLevel.level ?? 0) < 10 ? 4.0 : 2.0),
                                    decoration: BoxDecoration(
                                      color:
                                          itemLevel.level == itemLevel.maxLevel
                                              ? Colors.amber
                                              : Colors.black,
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: Text(
                                      itemLevel.level.toString(),
                                      style: TextStyle(
                                        fontSize: 8.0,
                                        fontWeight: FontWeight.bold,
                                        color: itemLevel.level ==
                                                itemLevel.maxLevel
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ] else
                              ColorFiltered(
                                colorFilter: const ColorFilter.mode(
                                  Colors.black,
                                  BlendMode.saturation,
                                ),
                                child: Image.asset(
                                  '$imagePath$itemImage.png',
                                  height: 42.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
