import 'package:flutter/material.dart';
import 'package:s_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:s_store/common/widgets/images/s_circular_image.dart';
import 'package:s_store/common/widgets/texts/s_brand_title_with_verified_icon.dart';
import 'package:s_store/features/shop/models/brand_model.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/constants/enums.dart';
import 'package:s_store/utils/constants/image_strings.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/utils/helpers/helper_functions.dart';

class SBrandCard extends StatelessWidget {
  const SBrandCard({
    super.key,
    required this.showBorder,
    this.onTap,
    this.brand,
  });

  final BrandModel? brand;
  final bool showBorder;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);
    final b = brand ?? BrandModel(id: '1', image: SImages.nikeLogo, name: 'Nike', productsCount: 256);
    final isNetwork = b.image.startsWith('http');

    return GestureDetector(
      onTap: onTap,
      child: SRoundedContainer(
        padding: const EdgeInsets.all(SSizes.sm),
        showBorder: showBorder,
        backgroundColor: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// -- Brand Icon
            Flexible(
              child: SCircularImage(
                image: b.image.isNotEmpty ? b.image : SImages.clothIcon,
                isNetworkImage: isNetwork,
                backgroundColor: Colors.transparent,
                overlayColor: dark ? SColors.white : SColors.black,
              ),
            ),
            const SizedBox(width: SSizes.spaceBtwItems / 2),

            /// -- Brand Text & Products Count
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SBrandTitleWithVerifiedIcon(
                    title: b.name,
                    brandTextSize: TextSizes.large,
                  ),
                  Text(
                    '${b.productsCount ?? 0} Products',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
