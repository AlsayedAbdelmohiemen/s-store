import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:s_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:s_store/common/widgets/images/s_rounded_image.dart';
import 'package:s_store/common/widgets/products/favorite_icon/favorite_icon.dart';
import 'package:s_store/common/widgets/texts/product_price_text.dart';
import 'package:s_store/common/widgets/texts/product_title_text.dart';
import 'package:s_store/common/widgets/texts/s_brand_title_with_verified_icon.dart';
import 'package:s_store/features/shop/controllers/product_controller.dart';
import 'package:s_store/features/shop/controllers/variation_controller.dart';
import 'package:s_store/features/shop/models/product_model.dart';
import 'package:s_store/features/shop/views/product_details/product_detail.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/utils/helpers/helper_functions.dart';

class SProductsCardHorizontal extends StatelessWidget {
  const SProductsCardHorizontal({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);
    final controller = ProductController.instance;
    final salePercentage = controller.calculateSalePercentage(product.price, product.salePrice);
    final isNetworkImage = product.thumbnail.startsWith('http');

    return GestureDetector(
      onTap: () {
        if (Get.isRegistered<VariationController>()) {
          VariationController.instance.resetSelectedAttributes();
        }
        Get.to(() => ProductDetailScreen(product: product));
      },
      child: Container(
        width: 310,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SSizes.productImageRadius),
          color: dark ? SColors.darkerGrey : SColors.white,
        ),
        child: Row(
          children: [
            /// -- Thumbnail
            SRoundedContainer(
              height: 120,
              padding: const EdgeInsets.all(SSizes.sm),
              backgroundColor: dark ? SColors.dark : SColors.light,
              child: Stack(
                children: [
                  /// Thumbnail Image
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: SRoundedImage(
                      imageUrl: product.thumbnail,
                      applyImageRadius: true,
                      isNetworkImage: isNetworkImage,
                    ),
                  ),

                  /// Sale Tag
                  if (salePercentage != null)
                    Positioned(
                      top: 12,
                      child: SRoundedContainer(
                        radius: SSizes.sm,
                        backgroundColor:
                            SColors.secondaryColor.withValues(alpha: 0.8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: SSizes.sm,
                          vertical: SSizes.x5,
                        ),
                        child: Text(
                          '$salePercentage%',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .apply(color: SColors.black),
                        ),
                      ),
                    ),

                  /// Favorite Icon Button
                  Positioned(
                    top: 0,
                    right: 0,
                    child: SFavoriteIcon(
                      productId: product.id,
                    ),
                  ),
                ],
              ),
            ),

            /// -- Details
            SizedBox(
              width: 172,
              child: Padding(
                padding: const EdgeInsets.only(top: SSizes.sm, left: SSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SProductTitleText(
                          title: product.title,
                          smallSize: true,
                        ),
                        const SizedBox(height: SSizes.spaceBtwItems / 2),
                        SBrandTitleWithVerifiedIcon(title: product.brand?.name ?? ''),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Pricing
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product.productType == 'single' && product.salePrice > 0)
                                Text(
                                  '\$${product.price}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .apply(decoration: TextDecoration.lineThrough),
                                ),
                              SProductPriceText(price: controller.getProductPrice(product)),
                            ],
                          ),
                        ),

                        /// Add to cart button
                        Container(
                          decoration: const BoxDecoration(
                            color: SColors.dark,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(SSizes.cardRadiusMd),
                              bottomRight:
                                  Radius.circular(SSizes.productImageRadius),
                            ),
                          ),
                          child: const SizedBox(
                            width: SSizes.iconLg * 1.2,
                            height: SSizes.iconLg * 1.2,
                            child: Center(
                              child: Icon(Iconsax.add, color: SColors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
