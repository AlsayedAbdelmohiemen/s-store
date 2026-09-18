import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_store/common/widgets/appbar/appbar.dart';
import 'package:s_store/common/widgets/appbar/tapbar.dart';
import 'package:s_store/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:s_store/common/widgets/layouts/grid_layout.dart';
import 'package:s_store/common/widgets/products/card/cart_menu_icon.dart';
import 'package:s_store/common/widgets/texts/section_heading.dart';
import 'package:s_store/common/widgets/brands/brand_card.dart';
import 'package:s_store/features/shop/controllers/category_controller.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/helpers/helper_functions.dart';
import 'package:s_store/common/widgets/shimmers/brands_shimmer.dart';
import 'package:s_store/features/shop/controllers/brand_controller.dart';
import '../../../../utils/constants/sizes.dart';
import '../brand/all_brands.dart';
import '../brand/brand_products.dart';
import '../cart/cart.dart';
import 'widgets/category_tab.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brandController = Get.put(BrandController());
    final categoryController = Get.isRegistered<CategoryController>()
        ? CategoryController.instance
        : Get.put(CategoryController());

    return Obx(() {
      final categories = categoryController.featuredCategories.isNotEmpty
          ? categoryController.featuredCategories
          : categoryController.allCategories
              .where((c) => c.parentId.isEmpty || c.parentId == '0')
              .toList();

      if (categories.isEmpty) {
        return Scaffold(
          appBar: SAppBar(
            title: Text(
              "Store",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      return DefaultTabController(
        key: ValueKey(categories.map((e) => e.id).join(',')),
        length: categories.length,
        child: Scaffold(
          appBar: SAppBar(
            title: Text(
              "Store",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            actions: [
              SCartCounterIcon(
                onPressed: () => Get.to(() => const CartScreen()),
              )
            ],
          ),
          body: NestedScrollView(
            headerSliverBuilder: (_, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  floating: true,
                  backgroundColor: SHelperFunctions.isDarkMode(context)
                      ? SColors.black
                      : SColors.white,
                  expandedHeight: 440,
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.all(SSizes.defaultSpace),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        /// -- Search Bar
                        const SizedBox(height: SSizes.spaceBtwItems),
                        const SSearchContainer(
                          text: "Search in Store",
                          showBorder: true,
                          showBackground: false,
                          padding: EdgeInsets.zero,
                        ),
                        const SizedBox(height: SSizes.spaceBtwSections),

                        /// -- Featured Brands
                        SSectionHeading(
                          title: "Featured Brands",
                          onPressed: () => Get.to(() => const AllBrandsScreen()),
                        ),
                        const SizedBox(height: SSizes.spaceBtwItems / 1.5),

                        /// -- Brands Grid
                        Obx(() {
                          if (brandController.isLoading.value) return const SBrandsShimmer();

                          if (brandController.featuredBrands.isEmpty) {
                            return Center(
                              child: Text(
                                'No Data Found!',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            );
                          }

                          return SGridLayout(
                            itemCount: brandController.featuredBrands.length,
                            mainAxisExtent: 80,
                            itemBuilder: (_, index) {
                              final brand = brandController.featuredBrands[index];
                              return SBrandCard(
                                showBorder: true,
                                brand: brand,
                                onTap: () => Get.to(() => BrandProducts(brand: brand)),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                  bottom: STabBar(
                    tabs: categories
                        .map((category) => Tab(child: Text(category.name)))
                        .toList(),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: categories
                  .map((category) => CategoryTab(category: category))
                  .toList(),
            ),
          ),
        ),
      );
    });
  }
}
