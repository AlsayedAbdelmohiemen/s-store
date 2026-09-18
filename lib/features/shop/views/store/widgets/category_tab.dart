import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_store/common/widgets/layouts/grid_layout.dart';
import 'package:s_store/common/widgets/products/products_card/product_card_vertical.dart';
import 'package:s_store/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:s_store/common/widgets/texts/section_heading.dart';
import 'package:s_store/features/shop/controllers/category_controller.dart';
import 'package:s_store/features/shop/models/category_model.dart';
import 'package:s_store/features/shop/views/all_products/all_products.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/utils/helpers/cloud_helper_functions.dart';
import 'category_brands.dart';

class CategoryTab extends StatelessWidget {
  const CategoryTab({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(SSizes.defaultSpace),
          child: Column(
            children: [
              /// -- Category Brands
              CategoryBrands(category: category),
              const SizedBox(height: SSizes.spaceBtwItems),

              /// -- Products "You Might Like"
              FutureBuilder(
                future: controller.getCategoryProducts(categoryId: category.id),
                builder: (context, snapshot) {
                  /// Helper Function: Check Record State
                  final response = TCloudHelperFunctions.checkMultiRecordState(
                    snapshot: snapshot,
                    loader: const SVerticalProductShimmer(),
                  );
                  if (response != null) return response;

                  /// Record Found!
                  final products = snapshot.data!;

                  return Column(
                    children: [
                      SSectionHeading(
                        title: "You might Like",
                        onPressed: () => Get.to(
                          () => AllProducts(
                            title: category.name,
                            futureMethod: controller.getCategoryProducts(
                              categoryId: category.id,
                              limit: -1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: SSizes.spaceBtwItems),
                      SGridLayout(
                        itemCount: products.length,
                        itemBuilder: (_, index) => SProductsCardVertical(product: products[index]),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: SSizes.spaceBtwSections),
            ],
          ),
        ),
      ],
    );
  }
}

