import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../common/widgets/products/products_card/product_card_vertical.dart';
import '../../../../common/widgets/products/sortable/sortable_products.dart';
import '../../../../common/widgets/shimmers/vertical_product_shimmer.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/product_search_controller.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  static const List<String> popularTags = [
    'Nike',
    'Adidas',
    'Jordan',
    'Puma',
    'Shoes',
    'Shirt',
    'Tracksuit',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductSearchController());
    final productController = Get.isRegistered<ProductController>()
        ? ProductController.instance
        : Get.put(ProductController());
    final dark = SHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: SAppBar(
        showBackArrow: true,
        title: Text(
          'Search Store',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// -- Search Input Field
              TextFormField(
                controller: controller.searchController,
                autofocus: true,
                onChanged: (value) => controller.searchQuery.value = value,
                onFieldSubmitted: (value) => controller.searchProducts(value),
                decoration: InputDecoration(
                  hintText: 'Search for products, brands...',
                  prefixIcon: const Icon(Iconsax.search_normal),
                  suffixIcon: Obx(
                    () => controller.searchQuery.value.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Iconsax.close_circle),
                            onPressed: () => controller.clearSearch(),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
              const SizedBox(height: SSizes.spaceBtwSections),

              /// -- Reactive Body
              Obx(() {
                // 1. Loading State
                if (controller.isLoading.value) {
                  return const SVerticalProductShimmer();
                }

                // 2. Query is active
                if (controller.searchQuery.value.trim().isNotEmpty) {
                  // No results found
                  if (controller.searchResults.isEmpty) {
                    return TAnimationLoaderWidget(
                      text:
                          'No products found matching "${controller.searchQuery.value}"',
                      animation: SImages.emptyAnimation,
                    );
                  }

                  // Results found
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Found ${controller.searchResults.length} Products',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: SSizes.spaceBtwItems),
                      SSortableProducts(products: controller.searchResults),
                    ],
                  );
                }

                // 3. Initial Empty Query State: Show Popular Searches, History & Featured Suggestions
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Search History (if available)
                    if (controller.searchHistory.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SSectionHeading(
                            title: 'Recent Searches',
                            showActionsButton: false,
                          ),
                          TextButton(
                            onPressed: () => controller.clearHistory(),
                            child: const Text('Clear All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: SSizes.spaceBtwItems / 2),
                      Wrap(
                        spacing: SSizes.sm,
                        runSpacing: SSizes.xs,
                        children: controller.searchHistory
                            .map(
                              (tag) => ActionChip(
                                label: Text(tag),
                                avatar: const Icon(
                                  Iconsax.clock,
                                  size: SSizes.iconSm,
                                ),
                                onPressed: () => controller.applySearchTag(tag),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: SSizes.spaceBtwSections),
                    ],

                    /// Popular Keywords
                    const SSectionHeading(
                      title: 'Popular Brands & Categories',
                      showActionsButton: false,
                    ),
                    const SizedBox(height: SSizes.spaceBtwItems),
                    Wrap(
                      spacing: SSizes.sm,
                      runSpacing: SSizes.xs,
                      children: popularTags
                          .map(
                            (tag) => ActionChip(
                              backgroundColor:
                                  dark ? SColors.darkerGrey : SColors.light,
                              label: Text(tag),
                              onPressed: () => controller.applySearchTag(tag),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: SSizes.spaceBtwSections),

                    /// Popular Products Preview
                    const SSectionHeading(
                      title: 'Explore Popular Items',
                      showActionsButton: false,
                    ),
                    const SizedBox(height: SSizes.spaceBtwItems),
                    Obx(
                      () => SGridLayout(
                        itemCount:
                            productController.featuredProducts.take(4).length,
                        itemBuilder: (_, index) => SProductsCardVertical(
                          product:
                              productController.featuredProducts[index],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
