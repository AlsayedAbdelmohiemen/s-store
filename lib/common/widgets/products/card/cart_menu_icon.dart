import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:s_store/features/shop/controllers/cart_controller.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/helpers/helper_functions.dart';

class SCartCounterIcon extends StatelessWidget {
  const SCartCounterIcon({
    super.key,
    required this.onPressed,
    this.iconColor,
  });

  final VoidCallback onPressed;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());
    final dark = SHelperFunctions.isDarkMode(context);

    return Stack(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            Iconsax.shopping_bag,
            color: iconColor,
          ),
        ),
        Positioned(
          right: 0,
          child: IgnorePointer(
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: dark ? SColors.white : SColors.black,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Obx(
                  () => Text(
                    controller.noOfCartItems.value.toString(),
                    style: Theme.of(context).textTheme.labelLarge!.apply(
                          color: dark ? SColors.black : SColors.white,
                          fontSizeFactor: 0.8,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
