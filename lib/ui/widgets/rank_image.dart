import 'package:flutter/material.dart';

import '../../utils/constants/app_constants.dart';

class RankImage extends StatelessWidget {
  const RankImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
  });

  final String? imageUrl;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return Image.asset(
        '${AppConstants.leaguesImagePath}${AppConstants.unrankedImage}',
        height: height,
        width: width,
        fit: BoxFit.cover,
      );
    }
    return FadeInImage.assetNetwork(
      image: imageUrl!,
      placeholder: AppConstants.placeholderImage,
      height: height,
      width: width,
      fit: BoxFit.cover,
    );
  }
}
