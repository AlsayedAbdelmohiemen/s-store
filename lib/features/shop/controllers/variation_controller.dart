import 'package:get/get.dart';
import '../models/product_model.dart';
import '../models/product_variation_model.dart';
import 'images_controller.dart';

class VariationController extends GetxController {
  static VariationController get instance => Get.find();

  /// Variables
  RxMap<String, dynamic> selectedAttributes = <String, dynamic>{}.obs;
  RxString variationStockStatus = ''.obs;
  Rx<ProductVariationModel> selectedVariation = ProductVariationModel.empty().obs;

  /// -- Select Attribute and Match Variation
  void onAttributeSelected(ProductModel product, String attributeName, String attributeValue) {
    // When attribute is selected we first add that attribute to selectedAttributes
    final currentAttributes = Map<String, dynamic>.from(selectedAttributes);
    currentAttributes[attributeName] = attributeValue;
    selectedAttributes[attributeName] = attributeValue;

    // Try to find the matching variation that matches all selected attributes
    final matchingVariation = product.productVariations!.firstWhere(
      (variation) => _isSameAttributeValues(variation.attributeValues, currentAttributes),
      orElse: () => ProductVariationModel.empty(),
    );

    // Show the selected Variation image as Main Image if present
    if (matchingVariation.image.isNotEmpty) {
      if (Get.isRegistered<ImagesController>()) {
        ImagesController.instance.selectedProductImage.value = matchingVariation.image;
      }
    }

    // Assign selected Variation
    selectedVariation.value = matchingVariation;

    // Update selected product variation status
    getProductVariationStockStatus();
  }

  /// -- Check if selected attributes matches any variation attributes
  bool _isSameAttributeValues(
    Map<String, String> variationAttributes,
    Map<String, dynamic> selectedAttributes,
  ) {
    // If selectedAttributes count does not match variationAttributes count, return false
    if (variationAttributes.length != selectedAttributes.length) return false;

    // If any attribute value differs, return false
    for (final key in variationAttributes.keys) {
      if (variationAttributes[key] != selectedAttributes[key]) return false;
    }

    return true;
  }

  /// -- Check Attribute availability / Stock in Variation
  Set<String?> getAttributesAvailabilityInVariation(
    List<ProductVariationModel> variations,
    String attributeName,
  ) {
    // Pass variations to check which attribute values are available and in stock
    final availableVariationAttributeValues = variations
        .where((variation) =>
            variation.attributeValues[attributeName] != null &&
            variation.attributeValues[attributeName]!.isNotEmpty &&
            variation.stock > 0)
        .map((variation) => variation.attributeValues[attributeName])
        .toSet();

    return availableVariationAttributeValues;
  }

  /// -- Get Variation Price
  String getVariationPrice() {
    return (selectedVariation.value.salePrice > 0
            ? selectedVariation.value.salePrice
            : selectedVariation.value.price)
        .toStringAsFixed(1);
  }

  /// -- Check Product Variation Stock Status
  void getProductVariationStockStatus() {
    variationStockStatus.value =
        selectedVariation.value.stock > 0 ? 'In Stock' : 'Out of Stock';
  }

  /// -- Reset Selected Attributes when switching products
  void resetSelectedAttributes() {
    selectedAttributes.clear();
    variationStockStatus.value = '';
    selectedVariation.value = ProductVariationModel.empty();
  }
}
