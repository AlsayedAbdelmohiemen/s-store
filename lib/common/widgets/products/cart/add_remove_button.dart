import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:s_store/common/widgets/icons/circular_icon.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/utils/helpers/helper_functions.dart';

class SProductQuantityWithAddRemoveButton extends StatelessWidget {
  const SProductQuantityWithAddRemoveButton({
    super.key,
    required this.quantity,
    this.add,
    this.remove,
    this.width = 32,
    this.height = 32,
    this.size = SSizes.md,
  });

  final int quantity;
  final VoidCallback? add;
  final VoidCallback? remove;
  final double width, height, size;

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SCircularIcon(
          icon: Iconsax.minus,
          width: width,
          height: height,
          size: size,
          color: dark ? SColors.white : SColors.black,
          backgroundColor: dark ? SColors.darkerGrey : SColors.light,
          onPressed: remove,
        ),
        const SizedBox(width: SSizes.spaceBtwItems),
        Text(quantity.toString(), style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(width: SSizes.spaceBtwItems),
        SCircularIcon(
          icon: Iconsax.add,
          width: width,
          height: height,
          size: size,
          color: SColors.white,
          backgroundColor: SColors.primaryColor,
          onPressed: add,
        ),
      ],
    );
  }
}
