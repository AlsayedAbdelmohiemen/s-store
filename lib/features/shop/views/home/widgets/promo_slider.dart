import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../../../../../common/widgets/images/s_rounded_image.dart';
import '../../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/banner_controller.dart';
import '../../cart/cart.dart';
import '../../checkout/checkout.dart';
import '../../orders/order.dart';
import '../../store/store.dart';
import '../../wishlist/views/wishlist_screen.dart';
import '../../../../personalization/screens/profile/user_profile_screen.dart';

class SPromoSlider extends StatelessWidget {
  const SPromoSlider({super.key});

  /// Seamless redirection based on target screen
  void _navigateToScreen(String targetScreen) {
    if (targetScreen.isEmpty) return;
    try {
      final cleanScreen = targetScreen.toLowerCase().trim();
      if (cleanScreen == '/cart' || cleanScreen == 'cart') {
        Get.to(() => const CartScreen());
      } else if (cleanScreen == '/order' ||
          cleanScreen == 'order' ||
          cleanScreen == '/orders') {
        Get.to(() => const OrderScreen());
      } else if (cleanScreen == '/profile' || cleanScreen == 'profile') {
        Get.to(() => const UserProfileScreen());
      } else if (cleanScreen == '/checkout' || cleanScreen == 'checkout') {
        Get.to(() => const CheckoutScreen());
      } else if (cleanScreen == '/wishlist' ||
          cleanScreen == 'wishlist' ||
          cleanScreen == '/favourites' ||
          cleanScreen == 'favourites') {
        Get.to(() => const WishListScreen());
      } else if (cleanScreen == '/store' || cleanScreen == 'store') {
        Get.to(() => const StoreScreen());
      } else {
        Get.toNamed(targetScreen);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BannerController());

    return Obx(
      () {
        // Loader while fetching banners
        if (controller.isLoading.value) {
          return const SShimmerEffect(width: double.infinity, height: 190);
        }

        // Empty State
        if (controller.banners.isEmpty) {
          return const Center(child: Text('No Data Found!'));
        }

        return Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 1,
                onPageChanged: (index, _) =>
                    controller.updatePageIndicator(index),
              ),
              items: controller.banners
                  .map(
                    (banner) => SRoundedImage(
                      imageUrl: banner.imageUrl,
                      isNetworkImage: banner.imageUrl.startsWith('http'),
                      onPressed: () => _navigateToScreen(banner.targetScreen),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: SSizes.spaceBtwItems),
            Center(
              child: Obx(
                () => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < controller.banners.length; i++)
                      SCircularContainer(
                        height: 4,
                        width: 20,
                        margin: const EdgeInsets.only(right: 10),
                        backgroundColor:
                            controller.carousalCurrentIndex.value == i
                                ? SColors.primaryColor
                                : SColors.grey,
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
