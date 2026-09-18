import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:s_store/common/widgets/icons/circular_icon.dart';
import 'package:s_store/features/shop/controllers/cart_controller.dart';
import 'package:s_store/features/shop/models/product_model.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/utils/helpers/helper_functions.dart';

class SBottomAddToCart extends StatelessWidget {
  const SBottomAddToCart({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;
    controller.updateAlreadyAddedProductCount(product);
    final dark = SHelperFunctions.isDarkMode(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SSizes.defaultSpace,
        vertical: SSizes.defaultSpace / 2,
      ),
      decoration: BoxDecoration(
        color: dark ? SColors.darkerGrey : SColors.light,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(SSizes.cardRadiusLg),
          topRight: Radius.circular(SSizes.cardRadiusLg),
        ),
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SCircularIcon(
                  icon: Iconsax.minus,
                  backgroundColor: SColors.darkGrey,
                  width: 40,
                  height: 40,
                  color: SColors.white,
                  onPressed: () => controller.productQuantityInCart.value < 1
                      ? null
                      : controller.productQuantityInCart.value -= 1,
                ),
                const SizedBox(width: SSizes.spaceBtwItems),
                Text(
                  controller.productQuantityInCart.value.toString(),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(width: SSizes.spaceBtwItems),
                SCircularIcon(
                  icon: Iconsax.add,
                  backgroundColor: SColors.black,
                  width: 40,
                  height: 40,
                  color: SColors.white,
                  onPressed: () => controller.productQuantityInCart.value += 1,
                ),
              ],
            ),
            ElevatedButton(
              onPressed: controller.productQuantityInCart.value < 1
                  ? null
                  : () => controller.addToCart(product),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(SSizes.md),
                backgroundColor: SColors.black,
                side: const BorderSide(color: SColors.black),
              ),
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
