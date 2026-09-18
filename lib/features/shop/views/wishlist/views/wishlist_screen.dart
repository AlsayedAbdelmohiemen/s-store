import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:s_store/common/widgets/appbar/appbar.dart';
import 'package:s_store/common/widgets/icons/circular_icon.dart';
import 'package:s_store/common/widgets/layouts/grid_layout.dart';
import 'package:s_store/common/widgets/loaders/animation_loader.dart';
import 'package:s_store/common/widgets/products/products_card/product_card_vertical.dart';
import 'package:s_store/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:s_store/features/shop/controllers/favourites_controller.dart';
import 'package:s_store/features/shop/models/product_model.dart';
import 'package:s_store/navigation_menu.dart';
import 'package:s_store/utils/constants/image_strings.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/utils/helpers/cloud_helper_functions.dart';

class WishListScreen extends StatelessWidget {
  const WishListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = FavouritesController.instance;

    return Scaffold(
      appBar: SAppBar(
        title: Text(
          'Wishlist',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          SCircularIcon(
            icon: Iconsax.add,
            onPressed: () {
              final navController = Get.find<NavigationController>();
              navController.selectedIndex.value = 0;
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SSizes.defaultSpace),
          child: Obx(
            () {
              /// Empty State Widget
              final emptyWidget = TAnimationLoaderWidget(
                text: 'Whoops! Wishlist is Empty...',
                animation: SImages.emptyAnimation,
                showAction: true,
                actionText: "Let's add some",
                onActionPressed: () {
                  final navController = Get.find<NavigationController>();
                  navController.selectedIndex.value = 0;
                },
              );

              // If no favorites are saved, immediately show empty state
              if (controller.favorites.isEmpty || !controller.favorites.containsValue(true)) {
                return emptyWidget;
              }

              return FutureBuilder<List<ProductModel>>(
                future: controller.favoriteProducts(),
                builder: (context, snapshot) {
                  const loader = SVerticalProductShimmer(itemCount: 6);
                  final widget = TCloudHelperFunctions.checkMultiRecordState(
                    snapshot: snapshot,
                    loader: loader,
                    nothingFound: emptyWidget,
                  );
                  if (widget != null) return widget;

                  final products = snapshot.data!;
                  return SGridLayout(
                    itemCount: products.length,
                    itemBuilder: (_, index) => SProductsCardVertical(product: products[index]),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

