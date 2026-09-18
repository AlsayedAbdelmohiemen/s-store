import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_store/common/widgets/products/cart/add_remove_button.dart';
import 'package:s_store/common/widgets/products/cart/cart_item_widget.dart';
import 'package:s_store/common/widgets/texts/product_price_text.dart';
import 'package:s_store/features/shop/controllers/cart_controller.dart';
import 'package:s_store/utils/constants/sizes.dart';

class SCartItems extends StatelessWidget {
  const SCartItems({
    super.key,
    this.showAddRemoveButtons = true,
  });

  final bool showAddRemoveButtons;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;

    return Obx(
      () => ListView.separated(
        shrinkWrap: true,
        itemCount: cartController.cartItems.length,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, __) =>
            const SizedBox(height: SSizes.spaceBtwSections),
        itemBuilder: (_, index) {
          final item = cartController.cartItems[index];
          return Column(
            children: [
              /// -- Cart Item
              SCartItem(cartItem: item),
              if (showAddRemoveButtons)
                const SizedBox(height: SSizes.spaceBtwItems),

              /// -- Add & Remove Button Row with Total Price
              if (showAddRemoveButtons)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        /// Extra Space matching image alignment
                        const SizedBox(width: 70),

                        /// Add Remove Buttons
                        SProductQuantityWithAddRemoveButton(
                          quantity: item.quantity,
                          add: () => cartController.addOneToCart(item),
                          remove: () => cartController.removeOneFromCart(item),
                        ),
                      ],
                    ),

                    /// -- Product Total Price
                    SProductPriceText(
                      price: (item.price * item.quantity).toStringAsFixed(1),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
