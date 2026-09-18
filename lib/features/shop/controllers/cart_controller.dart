import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../utils/popups/loaders.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import 'variation_controller.dart';

class CartController extends GetxController {
  static CartController get instance => Get.isRegistered<CartController>()
      ? Get.find<CartController>()
      : Get.put(CartController());

  // Variables
  RxInt noOfCartItems = 0.obs;
  RxDouble totalCartPrice = 0.0.obs;
  RxInt productQuantityInCart = 0.obs;
  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;

  final _storage = GetStorage();

  VariationController get _variationController =>
      Get.isRegistered<VariationController>()
          ? Get.find<VariationController>()
          : Get.put(VariationController());

  @override
  void onInit() {
    super.onInit();
    loadCartItems();
  }

  /// Add Items in the cart
  void addToCart(ProductModel product) {
    // Quantity Check
    if (productQuantityInCart.value < 1) {
      TLoaders.customToast(message: 'Select Quantity');
      return;
    }

    // Variation Selected Check
    if (product.productType == 'variable') {
      if (_variationController.selectedVariation.value.id.isEmpty) {
        TLoaders.customToast(message: 'Select Variation');
        return;
      }

      // Out of Stock Check
      if (_variationController.selectedVariation.value.stock < 1) {
        TLoaders.warningSnackBar(
          message: 'Selected variation is out of stock.',
          title: 'Oh Snap!',
        );
        return;
      }
    } else {
      // Out of Stock Check for simple product
      if (product.stock < 1) {
        TLoaders.warningSnackBar(
          message: 'Selected Product is out of stock.',
          title: 'Oh Snap!',
        );
        return;
      }
    }

    // Convert the ProductModel to a CartItemModel with the given quantity
    final selectedCartItem =
        convertToCartItem(product, productQuantityInCart.value);

    // Check if already added in the Cart
    int index = cartItems.indexWhere((cartItem) =>
        cartItem.productId == selectedCartItem.productId &&
        cartItem.variationId == selectedCartItem.variationId);

    if (index >= 0) {
      // This item already exists in the cart, update quantity
      cartItems[index].quantity = selectedCartItem.quantity;
    } else {
      cartItems.add(selectedCartItem);
    }

    updateCart();
    TLoaders.customToast(message: 'Your Product has been added to the Cart.');
  }

  /// Add one quantity to cart item
  void addOneToCart(CartItemModel item) {
    int index = cartItems.indexWhere((cartItem) =>
        cartItem.productId == item.productId &&
        cartItem.variationId == item.variationId);

    if (index >= 0) {
      cartItems[index].quantity += 1;
    } else {
      cartItems.add(item);
    }
    updateCart();
  }

  /// Remove one quantity from cart item or show dialog
  void removeOneFromCart(CartItemModel item) {
    int index = cartItems.indexWhere((cartItem) =>
        cartItem.productId == item.productId &&
        cartItem.variationId == item.variationId);

    if (index >= 0) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity -= 1;
        updateCart();
      } else {
        // Show dialog before removing item
        removeFromCartDialog(index);
      }
    }
  }

  /// Dialog to confirm product removal
  void removeFromCartDialog(int index) {
    Get.defaultDialog(
      title: 'Remove Product',
      middleText: 'Are you sure you want to remove this product?',
      onConfirm: () {
        // Remove the item from the cart
        cartItems.removeAt(index);
        updateCart();
        TLoaders.customToast(message: 'Product removed from the Cart.');
        Get.back();
      },
      onCancel: () => Get.back(),
    );
  }

  /// Initialize already added product count
  void updateAlreadyAddedProductCount(ProductModel product) {
    if (product.productType == 'variable') {
      final variationId = _variationController.selectedVariation.value.id;
      if (variationId.isNotEmpty) {
        productQuantityInCart.value =
            getVariationQuantityInCart(product.id, variationId);
      } else {
        productQuantityInCart.value = 0;
      }
    } else {
      productQuantityInCart.value = getProductQuantityInCart(product.id);
    }
  }

  /// Convert ProductModel to CartItemModel
  CartItemModel convertToCartItem(ProductModel product, int quantity) {
    if (product.productType == 'variable') {
      final variation = _variationController.selectedVariation.value;
      return CartItemModel(
        productId: product.id,
        title: product.title,
        price: variation.salePrice > 0.0 ? variation.salePrice : variation.price,
        quantity: quantity,
        variationId: variation.id,
        image: variation.image.isNotEmpty ? variation.image : product.thumbnail,
        brandName: product.brand != null ? product.brand!.name : '',
        selectedVariation: variation.attributeValues,
      );
    } else {
      return CartItemModel(
        productId: product.id,
        title: product.title,
        price: product.salePrice > 0.0 ? product.salePrice : product.price,
        quantity: quantity,
        variationId: '',
        image: product.thumbnail,
        brandName: product.brand != null ? product.brand!.name : '',
        selectedVariation: null,
      );
    }
  }

  /// Update cart totals and save to storage
  void updateCart() {
    updateCartTotals();
    saveCartItems();
    cartItems.refresh();
  }

  /// Calculate total price and item count
  void updateCartTotals() {
    double calculatedTotalPrice = 0.0;
    int calculatedNoOfItems = 0;

    for (var item in cartItems) {
      calculatedTotalPrice += item.price * item.quantity.toDouble();
      calculatedNoOfItems += item.quantity;
    }

    totalCartPrice.value = calculatedTotalPrice;
    noOfCartItems.value = calculatedNoOfItems;
  }

  /// Save cart items in local storage
  void saveCartItems() {
    try {
      final cartItemStrings = cartItems.map((item) => item.toJson()).toList();
      _storage.write('cartItems', jsonEncode(cartItemStrings));
    } catch (_) {}
  }

  /// Load cart items from local storage
  void loadCartItems() {
    try {
      final cartItemStrings = _storage.read<String>('cartItems');
      if (cartItemStrings != null) {
        final decoded = jsonDecode(cartItemStrings) as List<dynamic>;
        cartItems.assignAll(
          decoded.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>)),
        );
        updateCartTotals();
      }
    } catch (_) {}
  }

  /// Get specific product quantity across cart
  int getProductQuantityInCart(String productId) {
    final foundItem = cartItems
        .where((item) => item.productId == productId)
        .fold(0, (previousValue, element) => previousValue + element.quantity);
    return foundItem;
  }

  /// Get specific variation quantity in cart
  int getVariationQuantityInCart(String productId, String variationId) {
    final foundItem = cartItems.firstWhere(
      (item) => item.productId == productId && item.variationId == variationId,
      orElse: () => CartItemModel.empty(),
    );
    return foundItem.quantity;
  }

  /// Clear all items in cart
  void clearCart() {
    productQuantityInCart.value = 0;
    cartItems.clear();
    updateCart();
  }
}
