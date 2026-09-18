import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_store/common/widgets/appbar/appbar.dart';
import 'package:s_store/common/widgets/images/s_rounded_image.dart';
import 'package:s_store/common/widgets/layouts/grid_layout.dart';
import 'package:s_store/common/widgets/products/products_card/product_card_vertical.dart';
import 'package:s_store/common/widgets/products/products_card/product_cart_horizontal.dart';
import 'package:s_store/common/widgets/shimmers/horizontal_product_shimmer.dart';
import 'package:s_store/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:s_store/common/widgets/texts/section_heading.dart';
import 'package:s_store/features/shop/controllers/category_controller.dart';
import 'package:s_store/features/shop/models/category_model.dart';
import 'package:s_store/features/shop/models/product_model.dart';
import 'package:s_store/features/shop/views/all_products/all_products.dart';
import 'package:s_store/utils/constants/image_strings.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/utils/helpers/cloud_helper_functions.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;

    return Scaffold(
      appBar: SAppBar(
        title: Text(category.name),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SSizes.defaultSpace),
          child: Column(
            children: [
              /// -- Banner
              SRoundedImage(
                width: double.infinity,
                imageUrl: category.image.startsWith('http')
                    ? category.image
                    : SImages.promoBanner3,
                isNetworkImage: category.image.startsWith('http'),
                applyImageRadius: true,
              ),
              const SizedBox(height: SSizes.spaceBtwSections),

              /// -- Sub-Categories
              FutureBuilder<List<CategoryModel>>(
                future: controller.getSubCategories(category.id),
                builder: (context, snapshot) {
                  /// Handle Loader, Error, or Empty
                  final widgetState = TCloudHelperFunctions.checkMultiRecordState(
                    snapshot: snapshot,
                    loader: const SVerticalProductShimmer(),
                  );
                  if (widgetState != null) {
                    // Fallback to direct products if no subcategories exist
                    return FutureBuilder<List<ProductModel>>(
                      future: controller.getCategoryProducts(
                        categoryId: category.id,
                        limit: -1,
                      ),
                      builder: (context, prodSnapshot) {
                        final prodWidget = TCloudHelperFunctions.checkMultiRecordState(
                          snapshot: prodSnapshot,
                          loader: const SVerticalProductShimmer(),
                          nothingFound: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: SSizes.spaceBtwSections,
                              ),
                              child: Text(
                                'No products found in ${category.name}!',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        );
                        if (prodWidget != null) return prodWidget;

                        final directProducts = prodSnapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SSectionHeading(
                              title: '${category.name} Products (${directProducts.length})',
                              showActionsButton: false,
                            ),
                            const SizedBox(height: SSizes.spaceBtwItems),
                            SGridLayout(
                              itemCount: directProducts.length,
                              itemBuilder: (_, index) =>
                                  SProductsCardVertical(product: directProducts[index]),
                            ),
                          ],
                        );
                      },
                    );
                  }

                  final subCategories = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: subCategories.length,
                    itemBuilder: (_, index) {
                      final subCategory = subCategories[index];

                      return FutureBuilder<List<ProductModel>>(
                        future: controller.getCategoryProducts(
                          categoryId: subCategory.id,
                          limit: -1,
                        ),
                        builder: (context, prodSnapshot) {
                          /// Handle Loader
                          const loader = SHorizontalProductShimmer();
                          final widget = TCloudHelperFunctions.checkMultiRecordState(
                            snapshot: prodSnapshot,
                            loader: loader,
                          );
                          if (widget != null) return widget;

                          final products = prodSnapshot.data!;
                          if (products.isEmpty) return const SizedBox.shrink();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Heading with subcategory name
                              SSectionHeading(
                                title: subCategory.name,
                                showActionsButton: true,
                                onPressed: () => Get.to(
                                  () => AllProducts(
                                    title: subCategory.name,
                                    futureMethod: controller.getCategoryProducts(
                                      categoryId: subCategory.id,
                                      limit: -1,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: SSizes.spaceBtwItems / 2),

                              /// Horizontal products list
                              SizedBox(
                                height: 120,
                                child: ListView.separated(
                                  itemCount: products.length,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(width: SSizes.spaceBtwItems),
                                  itemBuilder: (context, index) =>
                                      SProductsCardHorizontal(product: products[index]),
                                ),
                              ),
                              const SizedBox(height: SSizes.spaceBtwSections),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
