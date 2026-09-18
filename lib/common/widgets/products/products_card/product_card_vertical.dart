import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:s_store/common/widgets/texts/product_price_text.dart';
import 'package:s_store/common/widgets/texts/s_brand_title_with_verified_icon.dart';
import 'package:s_store/features/shop/controllers/product_controller.dart';
import 'package:s_store/features/shop/controllers/variation_controller.dart';
import 'package:s_store/features/shop/models/product_model.dart';
import 'package:s_store/features/shop/views/product_details/product_detail.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/utils/helpers/helper_functions.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../styles/shadows.dart';
import '../../custom_shapes/containers/rounded_container.dart';
import '../../images/s_rounded_image.dart';
import '../favorite_icon/favorite_icon.dart';
import '../../texts/product_title_text.dart';

class SProductsCardVertical extends StatelessWidget {
  const SProductsCardVertical({super.key, this.product});

  final ProductModel? product;

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);
    final controller = Get.isRegistered<ProductController>()
        ? ProductController.instance
        : Get.put(ProductController());
    final salePercentage = product != null
        ? controller.calculateSalePercentage(product!.price, product!.salePrice)
        : null;
    final isNetworkImage = product != null && product!.thumbnail.startsWith('http');

    return GestureDetector(
      onTap: () {
        if (Get.isRegistered<VariationController>()) {
          VariationController.instance.resetSelectedAttributes();
        }
        Get.to(() => ProductDetailScreen(product: product ?? ProductModel.empty()));
      },
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [SShadowsStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(SSizes.productImageRadius),
          color: dark ? SColors.darkerGrey : SColors.white,
        ),
        child: Column(
          children: [
            /// Thumbnail , wishlist button, discount tag
            SRoundedContainer(
              height: 180,
              padding: const EdgeInsets.all(SSizes.sm),
              backgroundColor: dark ? SColors.dark : SColors.light,
              child: Stack(
                children: [
                  /// Thumbnail image
                  Center(
                    child: SRoundedImage(
                      imageUrl: product?.thumbnail ?? SImages.productImage1,
                      applyImageRadius: true,
                      isNetworkImage: isNetworkImage,
                    ),
                  ),

                  /// Sale tag
                  if (salePercentage != null)
                    Positioned(
                      top: 12,
                      child: SRoundedContainer(
                        radius: SSizes.sm,
                        backgroundColor: SColors.secondaryColor.withValues(alpha: 0.8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: SSizes.sm, vertical: SSizes.x5),
                        child: Text(
                          "$salePercentage%",
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
                      productId: product?.id ?? '',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: SSizes.spaceBtwItems / 2,
            ),

            /// Details
            Padding(
              padding: const EdgeInsets.only(left: SSizes.sm),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SProductTitleText(
                      title: product?.title ?? 'Green Nike Air Shoes',
                      smallSize: true,
                    ),
                    const SizedBox(
                      height: SSizes.spaceBtwItems / 2,
                    ),
                    SBrandTitleWithVerifiedIcon(
                      title: product?.brand?.name ?? 'Nike',
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),

            /// Price and Add to Cart Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Price
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product != null &&
                          product!.productType == 'single' &&
                          product!.salePrice > 0)
                        Padding(
                          padding: const EdgeInsets.only(left: SSizes.sm),
                          child: Text(
                            '\$${product!.price}',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .apply(decoration: TextDecoration.lineThrough),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: SSizes.sm),
                        child: SProductPriceText(
                          price: product != null
                              ? controller.getProductPrice(product!)
                              : '35',
                        ),
                      ),
                    ],
                  ),
                ),

                /// Add to Cart
                Container(
                  decoration: const BoxDecoration(
                      color: SColors.dark,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(SSizes.cardRadiusMd),
                        bottomRight: Radius.circular(SSizes.productImageRadius),
                      )),
                  child: const SizedBox(
                    width: SSizes.iconLg * 1.2,
                    height: SSizes.iconLg * 1.2,
                    child: Center(
                      child: Icon(
                        Iconsax.add,
                        color: SColors.white,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}


