import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:s_store/common/widgets/texts/s_brand_title.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/constants/enums.dart';
import 'package:s_store/utils/constants/sizes.dart';

class SBrandTitleWithVerifiedIcon extends StatelessWidget {
  const SBrandTitleWithVerifiedIcon({
    super.key,
    required this.title,
    this.maxLines = 1,
    this.textAlign = TextAlign.center,
    this.brandTextSize = TextSizes.small,
    this.textColor,
    this.iconColor = SColors.primaryColor,
  });

  final Color? textColor, iconColor;
  final String title;
  final int maxLines;
  final TextAlign? textAlign;
  final TextSizes brandTextSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: SBrandTitleText(
            title: title,
            color: textColor,
            maxLines: maxLines,
            textAlign: textAlign,
            brandTextSize: brandTextSize,
          ),
        ),
        const SizedBox(width: SSizes.xs),
        Icon(
          Iconsax.verify5,
          color: iconColor,
          size: SSizes.iconXs,
        ),
      ],
    );
  }
}
