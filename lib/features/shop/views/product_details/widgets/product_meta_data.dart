import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:s_store/common/widgets/images/s_circular_image.dart';
import 'package:s_store/common/widgets/texts/product_price_text.dart';
import 'package:s_store/common/widgets/texts/product_title_text.dart';
import 'package:s_store/common/widgets/texts/s_brand_title_with_verified_icon.dart';
import 'package:s_store/features/shop/controllers/product_controller.dart';
import 'package:s_store/features/shop/models/product_model.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/constants/enums.dart';
import 'package:s_store/utils/constants/image_strings.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/utils/helpers/helper_functions.dart';

class SProductMetaData extends StatelessWidget {
  const SProductMetaData({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final darkMode = SHelperFunctions.isDarkMode(context);
    final controller = Get.isRegistered<ProductController>()
        ? ProductController.instance
        : Get.put(ProductController());
    final salePercentage = controller.calculateSalePercentage(product.price, product.salePrice);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Price & Sale Tag
        Row(
          children: [
            /// Sale Tag
            if (salePercentage != null) ...[
              SRoundedContainer(
                radius: SSizes.sm,
                backgroundColor: SColors.secondaryColor.withValues(alpha: 0.8),
                padding: const EdgeInsets.symmetric(
                  horizontal: SSizes.sm,
                  vertical: SSizes.xs,
                ),
                child: Text(
                  '$salePercentage%',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .apply(color: SColors.black),
                ),
              ),
              const SizedBox(width: SSizes.spaceBtwItems),
            ],

            /// Original Price (Strikethrough)
            if (product.productType == 'single' && product.salePrice > 0) ...[
              Text(
                '\$${product.price}',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .apply(decoration: TextDecoration.lineThrough),
              ),
              const SizedBox(width: SSizes.spaceBtwItems),
            ],

            /// Current / Sale Price
            SProductPriceText(
              price: controller.getProductPrice(product),
              isLarge: true,
            ),
          ],
        ),
        const SizedBox(height: SSizes.spaceBtwItems / 1.5),

        /// Title
        SProductTitleText(title: product.title),
        const SizedBox(height: SSizes.spaceBtwItems / 1.5),

        /// Stock Status
        Row(
          children: [
            const SProductTitleText(title: 'Status'),
            const SizedBox(width: SSizes.spaceBtwItems),
            Text(
              controller.getProductStockStatus(product.stock),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: SSizes.spaceBtwItems / 1.5),

        /// Brand
        Row(
          children: [
            SCircularImage(
              image: product.brand != null && product.brand!.image.isNotEmpty
                  ? product.brand!.image
                  : SImages.shoeIcon,
              isNetworkImage: product.brand?.image.startsWith('http') ?? false,
              width: 32,
              height: 32,
              overlayColor: darkMode ? SColors.white : SColors.black,
            ),
            const SizedBox(width: SSizes.xs),
            SBrandTitleWithVerifiedIcon(
              title: product.brand?.name ?? '',
              brandTextSize: TextSizes.medium,
            ),
          ],
        ),
      ],
    );
  }
}
