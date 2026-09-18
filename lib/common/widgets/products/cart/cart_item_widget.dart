import 'package:flutter/material.dart';
import 'package:s_store/common/widgets/images/s_rounded_image.dart';
import 'package:s_store/common/widgets/texts/product_title_text.dart';
import 'package:s_store/common/widgets/texts/s_brand_title_with_verified_icon.dart';
import 'package:s_store/features/shop/models/cart_item_model.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/constants/image_strings.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/utils/helpers/helper_functions.dart';

class SCartItem extends StatelessWidget {
  const SCartItem({
    super.key,
    required this.cartItem,
  });

  final CartItemModel cartItem;

  @override
  Widget build(BuildContext context) {
    final isNetwork = (cartItem.image ?? '').startsWith('http');

    return Row(
      children: [
        /// Image
        SRoundedImage(
          imageUrl: cartItem.image != null && cartItem.image!.isNotEmpty
              ? cartItem.image!
              : SImages.productImage1,
          isNetworkImage: isNetwork,
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(SSizes.sm),
          backgroundColor: SHelperFunctions.isDarkMode(context)
              ? SColors.darkerGrey
              : SColors.light,
        ),
        const SizedBox(width: SSizes.spaceBtwItems),

        /// Title, Price, & Variations
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (cartItem.brandName != null && cartItem.brandName!.isNotEmpty)
                SBrandTitleWithVerifiedIcon(title: cartItem.brandName!),
              Flexible(
                child: SProductTitleText(
                  title: cartItem.title,
                  maxLines: 1,
                ),
              ),

              /// Attributes
              if (cartItem.selectedVariation != null &&
                  cartItem.selectedVariation!.isNotEmpty)
                Text.rich(
                  TextSpan(
                    children: cartItem.selectedVariation!.entries
                        .expand((e) => [
                              TextSpan(
                                text: ' ${e.key} ',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              TextSpan(
                                text: '${e.value} ',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ])
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}