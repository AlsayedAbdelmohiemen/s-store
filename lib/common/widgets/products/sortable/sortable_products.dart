import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:s_store/common/widgets/layouts/grid_layout.dart';
import 'package:s_store/common/widgets/products/products_card/product_card_vertical.dart';
import 'package:s_store/features/shop/controllers/all_products_controller.dart';
import 'package:s_store/features/shop/models/product_model.dart';
import 'package:s_store/utils/constants/colors.dart' show SColors;
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/utils/helpers/helper_functions.dart';

class SSortableProducts extends StatelessWidget {
  const SSortableProducts({
    super.key,
    required this.products,
  });

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);
    final controller = Get.put(AllProductsController());
    controller.assignProducts(products);

    return Column(
      children: [
        /// Dropdown
        DropdownButtonFormField(
          initialValue: controller.selectedSortOption.value,
          focusColor: dark ? SColors.light : SColors.white,
          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
          items: [
            'Name',
            'Higher Price',
            'Lower Price',
            'Sale',
            'Newest',
            'Popularity',
          ]
              .map((option) =>
                  DropdownMenuItem(value: option, child: Text(option)))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              controller.sortProducts(value);
            }
          },
        ),
        const SizedBox(height: SSizes.spaceBtwSections),

        /// Products
        Obx(
          () => SGridLayout(
            itemCount: controller.products.length,
            itemBuilder: (_, index) => SProductsCardVertical(
              product: controller.products[index],
            ),
          ),
        ),
      ],
    );
  }
}
