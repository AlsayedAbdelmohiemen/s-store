import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_store/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:s_store/common/widgets/layouts/grid_layout.dart';
import 'package:s_store/common/widgets/products/products_card/product_card_vertical.dart';
import 'package:s_store/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:s_store/features/shop/controllers/category_controller.dart';
import 'package:s_store/features/shop/controllers/product_controller.dart';
import 'package:s_store/features/shop/views/all_products/all_products.dart';
import 'package:s_store/features/shop/views/home/widgets/home_appbar.dart';
import 'package:s_store/features/shop/views/home/widgets/home_categories.dart';
import 'package:s_store/features/shop/views/home/widgets/promo_slider.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/constants/sizes.dart';

import '../../../../common/widgets/custom_shapes/containers/search_container.dart';
import '../../../../common/widgets/texts/section_heading.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          if (Get.isRegistered<CategoryController>()) {
            CategoryController.instance.selectedCategoryId.value = '';
            await CategoryController.instance.fetchCategories(forceRefresh: true);
          }
          controller.fetchFeaturedProducts();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(children: [
          const SPrimaryHeaderContainer(
            child: Column(
              children: [
                /// AppBar
                SHomeAppBar(),
                SizedBox(
                  height: SSizes.defaultSpace,
                ),

                /// searchBar
                SSearchContainer(
                  text: "Search in Store",
                ),
                SizedBox(
                  height: SSizes.defaultSpace,
                ),

                ///Heading
                Padding(
                  padding: EdgeInsets.only(left: SSizes.defaultSpace),
                  child: Column(
                    children: [
                      SSectionHeading(
                        title: 'Popular Categories',
                        showActionsButton: false,
                        textColor: SColors.white,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: SSizes.spaceBtwItems,
                ),

                ///Categories
                SHomeCategories(),
                SizedBox(height: SSizes.spaceBtwSections),
              ],
            ),
          ),

          /// Body Carousel Slider
          Padding(
              padding: const EdgeInsets.all(SSizes.defaultSpace),
              child: Column(
                children: [
                  /// PromoSlider
                  const SPromoSlider(),
                  const SizedBox(
                    height: SSizes.spaceBtwSections,
                  ),
                  SSectionHeading(
                    title: "Popular Products",
                    onPressed: () => Get.to(
                      () => AllProducts(
                        title: "Popular Products",
                        futureMethod: controller.fetchAllFeaturedProducts(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: SSizes.spaceBtwItems,
                  ),

                  /// Popular products with Shimmer Loader
                  Obx(() {
                    if (controller.isLoading.value) return const SVerticalProductShimmer();

                    if (controller.featuredProducts.isEmpty) {
                      return Center(
                        child: Text(
                          'No Data Found!',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }

                    return SGridLayout(
                      itemCount: controller.featuredProducts.length,
                      itemBuilder: (_, index) => SProductsCardVertical(
                        product: controller.featuredProducts[index],
                      ),
                    );
                  }),
                ],
              ))
        ]),
        ),
      ),
    );
  }
}
