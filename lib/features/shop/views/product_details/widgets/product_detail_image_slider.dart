import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_store/common/widgets/appbar/appbar.dart';
import 'package:s_store/common/widgets/custom_shapes/curved_edges/curved_edge_widget.dart';
import 'package:s_store/common/widgets/images/s_rounded_image.dart';
import 'package:s_store/common/widgets/products/favorite_icon/favorite_icon.dart';
import 'package:s_store/features/shop/controllers/images_controller.dart';
import 'package:s_store/features/shop/models/product_model.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/utils/helpers/helper_functions.dart';

class SProductImageSlider extends StatefulWidget {
  const SProductImageSlider({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  State<SProductImageSlider> createState() => _SProductImageSliderState();
}

class _SProductImageSliderState extends State<SProductImageSlider> {
  late final ImagesController controller;
  late final List<String> images;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<ImagesController>()
        ? ImagesController.instance
        : Get.put(ImagesController());
    images = controller.getAllProductImages(widget.product);
    controller.selectedProductImage.value = widget.product.thumbnail;
  }

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);

    return SCurvedEdgeWidget(
      child: Container(
        color: dark ? SColors.darkerGrey : SColors.light,
        child: Stack(
          children: [
            /// Main Large Image
            SizedBox(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(SSizes.productImageRadius * 2),
                child: Center(
                  child: Obx(() {
                    final image = controller.selectedProductImage.value.isEmpty
                        ? widget.product.thumbnail
                        : controller.selectedProductImage.value;
                    if (image.isEmpty) return const SizedBox();
                    return GestureDetector(
                      onTap: () => controller.showEnlargedImage(image),
                      child: Image(
                        image: image.startsWith('http')
                            ? NetworkImage(image)
                            : AssetImage(image) as ImageProvider,
                        fit: BoxFit.contain,
                      ),
                    );
                  }),
                ),
              ),
            ),

            /// Image Slider (Horizontal Thumbnails)
            if (images.isNotEmpty)
              Positioned(
                right: 0,
                bottom: 30,
                left: SSizes.defaultSpace,
                child: SizedBox(
                  height: 80,
                  child: ListView.separated(
                    itemCount: images.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: SSizes.spaceBtwItems),
                    itemBuilder: (_, index) => Obx(() {
                      final current = controller.selectedProductImage.value.isEmpty
                          ? widget.product.thumbnail
                          : controller.selectedProductImage.value;
                      final imageSelected = current == images[index];
                      return SRoundedImage(
                        width: 80,
                        isNetworkImage: images[index].startsWith('http'),
                        backgroundColor: dark ? SColors.dark : SColors.white,
                        border: Border.all(
                          color: imageSelected
                              ? SColors.primaryColor
                              : Colors.transparent,
                          width: 2,
                        ),
                        padding: const EdgeInsets.all(SSizes.sm),
                        imageUrl: images[index],
                        onPressed: () =>
                            controller.selectedProductImage.value = images[index],
                      );
                    }),
                  ),
                ),
              ),

            /// Appbar Icons
            SAppBar(
              showBackArrow: true,
              actions: [
                SFavoriteIcon(
                  productId: widget.product.id,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
