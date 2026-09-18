import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/products/card/cart_menu_icon.dart';
import '../../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../../features/personalization/controllers/user_controller.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/texts.dart';
import '../../cart/cart.dart';

class SHomeAppBar extends StatelessWidget {
  const SHomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());

    return SAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            STexts.homeAppbarTitle,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .apply(color: SColors.grey),
          ),
          Obx(
            () {
              if (controller.profileLoading.value) {
                return const SShimmerEffect(width: 80, height: 15);
              } else {
                return Text(
                  controller.user.value.fullName.isNotEmpty
                      ? controller.user.value.fullName
                      : STexts.homeAppbarSubTitle,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .apply(color: SColors.white),
                );
              }
            },
          ),
        ],
      ),
      actions: [
        SCartCounterIcon(
          onPressed: () => Get.to(() => const CartScreen()),
          iconColor: SColors.white,
        )
      ],
    );
  }
}
