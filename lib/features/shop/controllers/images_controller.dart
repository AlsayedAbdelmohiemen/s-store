import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/sizes.dart';
import '../models/product_model.dart';

class ImagesController extends GetxController {
  static ImagesController get instance => Get.find();

  /// Variables
  RxString selectedProductImage = ''.obs;

  /// -- Get All Images from product and Variations
  List<String> getAllProductImages(ProductModel product) {
    // Use Set to add unique images only
    Set<String> images = {};

    // Load thumbnail image
    if (product.thumbnail.isNotEmpty) {
      images.add(product.thumbnail);
    }

    // Get all images from the Product Model if not null.
    if (product.images != null && product.images!.isNotEmpty) {
      images.addAll(product.images!);
    }

    // Get all images from the Product Variations if not null.
    if (product.productVariations != null && product.productVariations!.isNotEmpty) {
      images.addAll(
        product.productVariations!
            .where((variation) => variation.image.isNotEmpty)
            .map((variation) => variation.image),
      );
    }

    return images.toList();
  }

  /// -- Show Image Popup Dialog
  void showEnlargedImage(String image) {
    Get.to(
      fullscreenDialog: true,
      () => Dialog.fullscreen(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: SSizes.defaultSpace * 2,
                horizontal: SSizes.defaultSpace,
              ),
              child: Image(
                image: image.startsWith('http')
                    ? NetworkImage(image)
                    : AssetImage(image) as ImageProvider,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: SSizes.spaceBtwSections),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 150,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Close'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
