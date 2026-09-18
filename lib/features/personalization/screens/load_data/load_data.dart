import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/list_tiles/settings_menu_tile.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../data/dummy_data.dart';
import '../../../../data/repositories/banners/banner_repository.dart';
import '../../../../data/repositories/categories/category_repository.dart';
import '../../../../data/repositories/products/product_repository.dart';
import '../../../shop/controllers/banner_controller.dart';
import '../../../shop/controllers/category_controller.dart';
import '../../../shop/controllers/product_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';

class LoadDataScreen extends StatelessWidget {
  const LoadDataScreen({super.key});

  /// Function to upload categories dummy data
  Future<void> _uploadCategories() async {
    try {
      TFullScreenLoader.openLoadingDialog(
        'Uploading Categories...',
        SImages.cloudUploadingAnimation,
      );

      final categoryRepository = Get.put(CategoryRepository());
      await categoryRepository.uploadDummyData(TDummyData.categories);

      // Refresh CategoryController if active
      if (Get.isRegistered<CategoryController>()) {
        await CategoryController.instance.fetchCategories();
      }

      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(
        title: 'Congratulations',
        message: 'All Categories have been uploaded to Cloud Database successfully!',
      );
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// Function to upload banners dummy data
  Future<void> _uploadBanners() async {
    try {
      TFullScreenLoader.openLoadingDialog(
        'Uploading Banners...',
        SImages.cloudUploadingAnimation,
      );

      final bannerRepository = Get.put(BannerRepository());
      await bannerRepository.uploadDummyData(TDummyData.banners);

      // Refresh BannerController if active
      if (Get.isRegistered<BannerController>()) {
        await BannerController.instance.fetchBanners();
      }

      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(
        title: 'Congratulations',
        message: 'All Banners have been uploaded to Cloud Database successfully!',
      );
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// Function to upload products dummy data
  Future<void> _uploadProducts() async {
    try {
      TFullScreenLoader.openLoadingDialog(
        'Uploading Products...',
        SImages.cloudUploadingAnimation,
      );

      final productRepository = Get.put(ProductRepository());
      await productRepository.uploadDummyData(TDummyData.products);

      // Refresh ProductController if active
      if (Get.isRegistered<ProductController>()) {
        ProductController.instance.fetchFeaturedProducts();
      }

      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(
        title: 'Congratulations',
        message: 'All Products have been uploaded to Cloud Database successfully!',
      );
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SAppBar(
        title: Text('Upload Data'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SSizes.defaultSpace),
          child: Column(
            children: [
              /// -- Main Record Heading
              const SSectionHeading(
                title: 'Main Record',
                showActionsButton: false,
              ),
              const SizedBox(height: SSizes.spaceBtwItems),

              /// Categories
              SSettingsMenuTile(
                icon: Iconsax.category,
                title: 'Upload Categories',
                subTitle: 'Upload categories dummy data to Cloud',
                trailing: IconButton(
                  icon: const Icon(Iconsax.arrow_up_3, size: 28, color: SColors.primaryColor),
                  onPressed: _uploadCategories,
                ),
                onTap: _uploadCategories,
              ),

              /// Brands
              SSettingsMenuTile(
                icon: Iconsax.shop,
                title: 'Upload Brands',
                subTitle: 'Upload brands dummy data to Cloud',
                trailing: IconButton(
                  icon: const Icon(Iconsax.arrow_up_3, size: 28, color: SColors.primaryColor),
                  onPressed: () {
                    TLoaders.customToast(message: 'Brands will be configured in Brands module.');
                  },
                ),
              ),

              /// Products
              SSettingsMenuTile(
                icon: Iconsax.shopping_cart,
                title: 'Upload Products',
                subTitle: 'Upload products dummy data to Cloud',
                trailing: IconButton(
                  icon: const Icon(Iconsax.arrow_up_3, size: 28, color: SColors.primaryColor),
                  onPressed: _uploadProducts,
                ),
                onTap: _uploadProducts,
              ),

              /// Banners
              SSettingsMenuTile(
                icon: Iconsax.image,
                title: 'Upload Banners',
                subTitle: 'Upload banners dummy data to Cloud',
                trailing: IconButton(
                  icon: const Icon(Iconsax.arrow_up_3, size: 28, color: SColors.primaryColor),
                  onPressed: _uploadBanners,
                ),
                onTap: _uploadBanners,
              ),

              const SizedBox(height: SSizes.spaceBtwSections),

              /// -- Relationships Heading
              const SSectionHeading(
                title: 'Relationships',
                showActionsButton: false,
              ),
              const Text(
                'Make sure you have already uploaded all the content above.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: SSizes.spaceBtwItems),

              /// Brand & Categories Relation Data
              SSettingsMenuTile(
                icon: Iconsax.link,
                title: 'Upload Brands & Categories Relation Data',
                subTitle: 'Upload relationship between brands & categories',
                trailing: IconButton(
                  icon: const Icon(Iconsax.arrow_up_3, size: 28, color: SColors.primaryColor),
                  onPressed: () {
                    TLoaders.customToast(message: 'Relational data configured with Brands & Categories.');
                  },
                ),
              ),

              /// Product Categories Relation Data
              SSettingsMenuTile(
                icon: Iconsax.link,
                title: 'Upload Product Categories Relational Data',
                subTitle: 'Upload relationship between products & categories',
                trailing: IconButton(
                  icon: const Icon(Iconsax.arrow_up_3, size: 28, color: SColors.primaryColor),
                  onPressed: () {
                    TLoaders.customToast(message: 'Relational data configured with Products & Categories.');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
