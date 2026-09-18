import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';
import 'package:s_store/common/widgets/texts/section_heading.dart';
import 'package:s_store/features/shop/controllers/cart_controller.dart';
import 'package:s_store/features/shop/controllers/variation_controller.dart';
import 'package:s_store/features/shop/models/product_model.dart';
import 'package:s_store/features/shop/views/checkout/checkout.dart';
import 'package:s_store/features/shop/views/product_details/widgets/bottom_add_to_cart_widget.dart';
import 'package:s_store/features/shop/views/product_details/widgets/product_attributes.dart';
import 'package:s_store/features/shop/views/product_details/widgets/product_detail_image_slider.dart';
import 'package:s_store/features/shop/views/product_details/widgets/product_meta_data.dart';
import 'package:s_store/features/shop/views/product_details/widgets/rating_share_widget.dart';
import 'package:s_store/features/shop/views/product_reviews/product_reviews.dart';
import 'package:s_store/utils/constants/sizes.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SBottomAddToCart(product: product),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 1 - Product Image Slider
            SProductImageSlider(product: product),

            /// 2 - Product Details
            Padding(
              padding: const EdgeInsets.only(
                right: SSizes.defaultSpace,
                left: SSizes.defaultSpace,
                bottom: SSizes.defaultSpace,
              ),
              child: Column(
                children: [
                  /// - Rating & Share Button
                  const SRatingAndShare(),

                  /// - Price, Title, Stock & Brand
                  SProductMetaData(product: product),

                  /// - Attributes (Colors & Sizes)
                  if (product.productType == 'variable' ||
                      (product.productAttributes != null &&
                          product.productAttributes!.isNotEmpty)) ...[
                    SProductAttributes(product: product),
                    const SizedBox(height: SSizes.spaceBtwSections),
                  ],

                  /// - Checkout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final cartController = CartController.instance;

                        // If product quantity is 0 or less, default to 1
                        if (cartController.productQuantityInCart.value < 1) {
                          cartController.productQuantityInCart.value = 1;
                        }

                        // Add product to cart (performs stock & variation validation)
                        cartController.addToCart(product);

                        // Verify that this product was successfully added to cart before navigating
                        final isAdded = product.productType == 'variable'
                            ? (Get.isRegistered<VariationController>() &&
                                cartController.getVariationQuantityInCart(
                                      product.id,
                                      VariationController.instance.selectedVariation.value.id,
                                    ) >
                                    0)
                            : cartController.getProductQuantityInCart(product.id) > 0;

                        if (isAdded) {
                          Get.to(() => const CheckoutScreen());
                        }
                      },
                      child: const Text('Checkout'),
                    ),
                  ),
                  const SizedBox(height: SSizes.spaceBtwSections),

                  /// - Description
                  const SSectionHeading(
                    title: 'Description',
                    showActionsButton: false,
                  ),
                  const SizedBox(height: SSizes.spaceBtwItems),
                  ReadMoreText(
                    product.description ?? '',
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' Show more',
                    trimExpandedText: ' Less',
                    moreStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                    lessStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  /// - Reviews
                  const Divider(),
                  const SizedBox(height: SSizes.spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SSectionHeading(
                        title: 'Reviews (199)',
                        showActionsButton: false,
                      ),
                      IconButton(
                        icon: const Icon(Iconsax.arrow_right_3, size: 18),
                        onPressed: () => Get.to(() => const ProductReviewsScreen()),
                      ),
                    ],
                  ),
                  const SizedBox(height: SSizes.spaceBtwSections),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
