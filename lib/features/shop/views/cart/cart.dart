import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_store/common/widgets/appbar/appbar.dart';
import 'package:s_store/common/widgets/loaders/animation_loader.dart';
import 'package:s_store/features/shop/controllers/cart_controller.dart';
import 'package:s_store/features/shop/views/cart/widgets/cart_items.dart';
import 'package:s_store/features/shop/views/checkout/checkout.dart';
import 'package:s_store/navigation_menu.dart';
import 'package:s_store/utils/constants/image_strings.dart';
import 'package:s_store/utils/constants/sizes.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;

    return Scaffold(
      /// -- AppBar
      appBar: SAppBar(
        showBackArrow: true,
        title: Text(
          'Cart',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),

      /// -- Items in Cart or Empty Loader
      body: Obx(
        () {
          final emptyWidget = TAnimationLoaderWidget(
            text: 'Whoops! Cart is EMPTY.',
            animation: SImages.cartAnimation,
            showAction: true,
            actionText: "Let's fill it",
            onActionPressed: () => Get.off(() => const NavigationMenu()),
          );

          if (controller.cartItems.isEmpty) {
            return emptyWidget;
          }

          return const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(SSizes.defaultSpace),
              child: SCartItems(),
            ),
          );
        },
      ),

      /// -- Checkout Button
      bottomNavigationBar: Obx(
        () {
          if (controller.cartItems.isEmpty) return const SizedBox();

          return Padding(
            padding: const EdgeInsets.all(SSizes.defaultSpace),
            child: ElevatedButton(
              onPressed: () => Get.to(() => const CheckoutScreen()),
              child: Text(
                'Checkout \$${controller.totalCartPrice.value.toStringAsFixed(1)}',
              ),
            ),
          );
        },
      ),
    );
  }
}