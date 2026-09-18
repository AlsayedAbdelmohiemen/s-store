import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:s_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:s_store/features/shop/controllers/order_controller.dart';
import 'package:s_store/features/shop/models/order_model.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/utils/helpers/helper_functions.dart';

class SOrderListItems extends StatelessWidget {
  const SOrderListItems({
    super.key,
    required this.orders,
  });

  final List<OrderModel> orders;

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: SSizes.spaceBtwItems),
      itemBuilder: (_, index) {
        final order = orders[index];

        return SRoundedContainer(
          showBorder: true,
          padding: const EdgeInsets.all(SSizes.md),
          backgroundColor: dark ? SColors.dark : SColors.light,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// -- Row 1 (Icon, Status & Order Date)
              Row(
                children: [
                  /// 1 - Icon
                  const Icon(Iconsax.ship),
                  const SizedBox(width: SSizes.spaceBtwItems / 2),

                  /// 2 - Status & Date
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.orderStatusText,
                          style: Theme.of(context).textTheme.bodyLarge!.apply(
                                color: SColors.primaryColor,
                                fontWeightDelta: 1,
                              ),
                        ),
                        Text(
                          order.formattedOrderDate,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),

                  /// 3 - Delete Icon Button
                  IconButton(
                    onPressed: () => OrderController.instance.deleteOrderWarning(order.id),
                    tooltip: 'Delete Order',
                    icon: const Icon(
                      Iconsax.trash,
                      color: Colors.red,
                      size: SSizes.iconSm,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SSizes.spaceBtwItems),

              /// -- Row 2 (Order ID & Shipping Date)
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        /// 1 - Tag Icon
                        const Icon(Iconsax.tag),
                        const SizedBox(width: SSizes.spaceBtwItems / 2),

                        /// 2 - Order ID
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                order.id.length > 8
                                    ? '[#${order.id.substring(0, 8)}]'
                                    : '[#${order.id}]',
                                style: Theme.of(context).textTheme.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        /// 1 - Calendar Icon
                        const Icon(Iconsax.calendar),
                        const SizedBox(width: SSizes.spaceBtwItems / 2),

                        /// 2 - Shipping Date
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Shipping Date',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                order.formattedDeliveryDate.isNotEmpty
                                    ? order.formattedDeliveryDate
                                    : 'Pending',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
