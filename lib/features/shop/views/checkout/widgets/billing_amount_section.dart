import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_store/features/shop/controllers/cart_controller.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/utils/helpers/pricing_calculator.dart';

class SBillingAmountSection extends StatelessWidget {
  const SBillingAmountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;

    return Obx(() {
      final subTotal = cartController.totalCartPrice.value;

      return Column(
        children: [
        /// -- SubTotal
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Subtotal', style: Theme.of(context).textTheme.bodyMedium),
            Text(
              '\$${subTotal.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: SSizes.spaceBtwItems / 2),

        /// -- Shipping Fee
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Shipping Fee', style: Theme.of(context).textTheme.bodyMedium),
            Text(
              '\$${SPricingCalculator.calculateShippingCost(subTotal, 'US')}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        const SizedBox(height: SSizes.spaceBtwItems / 2),

        /// -- Tax Fee
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tax Fee', style: Theme.of(context).textTheme.bodyMedium),
            Text(
              '\$${SPricingCalculator.calculateTax(subTotal, 'US')}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        const SizedBox(height: SSizes.spaceBtwItems / 2),

        /// -- Order Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Order Total', style: Theme.of(context).textTheme.bodyMedium),
            Text(
              '\$${SPricingCalculator.calculateTotalPrice(subTotal, 'US').toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        ],
      );
    });
  }
}
