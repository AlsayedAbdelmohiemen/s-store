import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_store/common/widgets/brands/brand_card.dart';
import 'package:s_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:s_store/features/shop/models/brand_model.dart';
import 'package:s_store/features/shop/views/brand/brand_products.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/utils/helpers/helper_functions.dart';

class SBrandShowCase extends StatelessWidget {
  const SBrandShowCase({
    super.key,
    required this.brand,
    required this.images,
  });

  final BrandModel brand;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => BrandProducts(brand: brand)),
      child: SRoundedContainer(
        showBorder: true,
        borderColor: SColors.darkGrey,
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.all(SSizes.md),
        margin: const EdgeInsets.only(bottom: SSizes.spaceBtwItems),
        child: Column(
          children: [
            /// Brand with Products Count
            SBrandCard(showBorder: false, brand: brand),
            const SizedBox(height: SSizes.spaceBtwItems),

            /// Brand Top 3 Product Images
            Row(
              children: images
                  .map((image) => brandTopProductImageWidget(image, context))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget brandTopProductImageWidget(String image, BuildContext context) {
    final isNetwork = image.startsWith('http://') || image.startsWith('https://');
    return Expanded(
      child: SRoundedContainer(
        height: 100,
        backgroundColor: SHelperFunctions.isDarkMode(context)
            ? SColors.darkerGrey
            : SColors.light,
        margin: const EdgeInsets.only(right: SSizes.sm),
        padding: const EdgeInsets.all(SSizes.md),
        child: Image(
          fit: BoxFit.contain,
          image: isNetwork
              ? NetworkImage(image)
              : AssetImage(image) as ImageProvider,
        ),
      ),
    );
  }
}

