import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_store/common/widgets/chips/choice_chip.dart';
import 'package:s_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:s_store/common/widgets/texts/product_price_text.dart';
import 'package:s_store/common/widgets/texts/product_title_text.dart';
import 'package:s_store/common/widgets/texts/section_heading.dart';
import 'package:s_store/features/shop/controllers/variation_controller.dart';
import 'package:s_store/features/shop/models/product_model.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/utils/helpers/helper_functions.dart';

class SProductAttributes extends StatefulWidget {
  const SProductAttributes({super.key, required this.product});

  final ProductModel product;

  @override
  State<SProductAttributes> createState() => _SProductAttributesState();
}

class _SProductAttributesState extends State<SProductAttributes> {
  late final VariationController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<VariationController>()
        ? VariationController.instance
        : Get.put(VariationController());
    controller.resetSelectedAttributes();
  }

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);

    if (widget.product.productAttributes == null || widget.product.productAttributes!.isEmpty) {
      return const SizedBox();
    }

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// -- Selected Attribute Pricing & Description
          if (controller.selectedVariation.value.id.isNotEmpty) ...[
            SRoundedContainer(
              padding: const EdgeInsets.all(SSizes.md),
              backgroundColor: dark ? SColors.darkerGrey : SColors.grey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title, Price and Stock Status
                  Row(
                    children: [
                      const SSectionHeading(
                        title: 'Variation',
                        showActionsButton: false,
                      ),
                      const SizedBox(width: SSizes.spaceBtwItems),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const SProductTitleText(
                                title: 'Price : ',
                                smallSize: true,
                              ),

                              /// Actual Price (Strikethrough)
                              if (controller.selectedVariation.value.salePrice > 0)
                                Text(
                                  '\$${controller.selectedVariation.value.price}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .apply(decoration: TextDecoration.lineThrough),
                                ),
                              const SizedBox(width: SSizes.spaceBtwItems),

                              /// Sale Price
                              SProductPriceText(
                                price: controller.getVariationPrice(),
                              ),
                            ],
                          ),

                          /// Stock Status
                          Row(
                            children: [
                              const SProductTitleText(
                                title: 'Stock : ',
                                smallSize: true,
                              ),
                              Text(
                                controller.variationStockStatus.value,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  /// Variation Description
                  if (controller.selectedVariation.value.description != null &&
                      controller.selectedVariation.value.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: SSizes.spaceBtwItems / 2),
                      child: SProductTitleText(
                        title: controller.selectedVariation.value.description!,
                        smallSize: true,
                        maxLines: 4,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: SSizes.spaceBtwItems),
          ],

          /// -- Dynamic Attributes Mapping
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.product.productAttributes!
                .map(
                  (attribute) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SSectionHeading(
                        title: attribute.name ?? '',
                        showActionsButton: false,
                      ),
                      const SizedBox(height: SSizes.spaceBtwItems / 2),
                      Wrap(
                        spacing: 8,
                        children: (attribute.values ?? []).map((attributeValue) {
                          final isSelected =
                              controller.selectedAttributes[attribute.name] ==
                                  attributeValue;
                          final available = controller
                              .getAttributesAvailabilityInVariation(
                                widget.product.productVariations ?? [],
                                attribute.name ?? '',
                              )
                              .contains(attributeValue);

                          return SChoiceChip(
                            text: attributeValue,
                            selected: isSelected,
                            onSelected: available
                                ? (selected) {
                                    if (selected) {
                                      controller.onAttributeSelected(
                                        widget.product,
                                        attribute.name ?? '',
                                        attributeValue,
                                      );
                                    }
                                  }
                                : null,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: SSizes.spaceBtwItems),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
