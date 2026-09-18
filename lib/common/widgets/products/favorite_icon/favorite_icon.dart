import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../features/shop/controllers/favourites_controller.dart';
import '../../../../utils/constants/colors.dart';
import 'package:s_store/common/widgets/icons/circular_icon.dart';

class SFavoriteIcon extends StatelessWidget {
  const SFavoriteIcon({
    super.key,
    required this.productId,
  });

  final String productId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<FavouritesController>()
        ? FavouritesController.instance
        : Get.put(FavouritesController());

    return Obx(
      () => SCircularIcon(
        icon: controller.isFavourite(productId) ? Iconsax.heart5 : Iconsax.heart,
        color: controller.isFavourite(productId) ? SColors.error : null,
        onPressed: () => controller.toggleFavoriteProduct(productId),
      ),
    );
  }
}
