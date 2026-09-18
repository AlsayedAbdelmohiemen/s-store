import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_store/common/widgets/appbar/appbar.dart';
import 'package:s_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:s_store/common/widgets/products/cart/coupon_widget.dart';
import 'package:s_store/features/shop/controllers/cart_controller.dart';
import 'package:s_store/features/shop/controllers/order_controller.dart';
import 'package:s_store/features/shop/views/cart/widgets/cart_items.dart';
import 'package:s_store/features/shop/views/checkout/widgets/billing_address_section.dart';
import 'package:s_store/features/shop/views/checkout/widgets/billing_amount_section.dart';
import 'package:s_store/features/shop/views/checkout/widgets/billing_payment_section.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/utils/helpers/helper_functions.dart';
import 'package:s_store/utils/helpers/pricing_calculator.dart';
import 'package:s_store/utils/popups/loaders.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);
    final cartController = CartController.instance;
    final orderController = Get.put(OrderController());

    return Scaffold(
      appBar: SAppBar(
        showBackArrow: true,
        title: Text(
          'Order Review',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SSizes.defaultSpace),
          child: Column(
            children: [
              /// -- Items in Cart
              const SCartItems(showAddRemoveButtons: false),
              const SizedBox(height: SSizes.spaceBtwSections),

              /// -- Coupon TextField
              const SCouponCode(),
              const SizedBox(height: SSizes.spaceBtwSections),

              /// -- Billing Section
              SRoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(SSizes.md),
                backgroundColor: dark ? SColors.black : SColors.white,
                child: const Column(
                  children: [
                    /// Pricing
                    SBillingAmountSection(),
                    SizedBox(height: SSizes.spaceBtwItems),

                    /// Divider
                    Divider(),
                    SizedBox(height: SSizes.spaceBtwItems),

                    /// Payment Methods
                    SBillingPaymentSection(),
                    SizedBox(height: SSizes.spaceBtwItems),

                    /// Address
                    SBillingAddressSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      /// -- Checkout Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(SSizes.defaultSpace),
        child: Obx(() {
          final subTotal = cartController.totalCartPrice.value;
          final totalAmount =
              SPricingCalculator.calculateTotalPrice(subTotal, 'US');

          return ElevatedButton(
            onPressed: subTotal > 0
                ? () => orderController.processOrder(totalAmount)
                : () => TLoaders.warningSnackBar(
                      title: 'Empty Cart',
                      message: 'Add items in the cart in order to proceed.',
                    ),
            child: Text('Checkout \$${totalAmount.toStringAsFixed(1)}'),
          );
        }),
      ),
    );
  }
}
