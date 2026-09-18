import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_store/common/widgets/success_screen/succes_screen.dart';
import 'package:s_store/data/repositories/authentication/authentication_repository.dart';
import 'package:s_store/data/repositories/order/order_repository.dart';
import 'package:s_store/features/personalization/controllers/address_controller.dart';
import 'package:s_store/features/shop/controllers/cart_controller.dart';
import 'package:s_store/features/shop/models/order_model.dart';
import 'package:s_store/navigation_menu.dart';
import 'package:s_store/utils/constants/enums.dart';
import 'package:s_store/utils/constants/image_strings.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/utils/popups/full_screen_loader.dart';
import 'package:s_store/utils/popups/loaders.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.isRegistered<OrderController>()
      ? Get.find<OrderController>()
      : Get.put(OrderController());

  // Variables
  final orderRepository = Get.put(OrderRepository());
  final RxList<OrderModel> myOrders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserOrders();
  }

  /// Fetch user's order history
  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      isLoading.value = true;
      final userOrders = await orderRepository.fetchUserOrders();
      myOrders.assignAll(userOrders);
      return userOrders;
    } catch (e) {
      TLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Warning dialog before deleting an order
  void deleteOrderWarning(String orderId) {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(SSizes.md),
      title: 'Delete Order',
      middleText: 'Are you sure you want to delete this order?',
      confirm: ElevatedButton(
        onPressed: () async {
          Get.back();
          await deleteOrder(orderId);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: SSizes.lg),
          child: Text('Delete'),
        ),
      ),
      cancel: OutlinedButton(
        child: const Text('Cancel'),
        onPressed: () => Get.back(),
      ),
    );
  }

  /// Delete order permanently
  Future<void> deleteOrder(String orderId) async {
    try {
      // 1. Remove from reactive list immediately for instant UI responsiveness
      myOrders.removeWhere((order) => order.id == orderId);

      // 2. Delete from repository (local disk + Supabase)
      await orderRepository.deleteOrder(orderId);

      TLoaders.customToast(message: 'Order deleted successfully.');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// Add methods for order processing
  void processOrder(double totalAmount) async {
    try {
      // 1. Check Address Selection
      final addressController = AddressController.instance;
      if (addressController.selectedAddress.value.id.isEmpty) {
        TLoaders.warningSnackBar(
          title: 'Empty Address',
          message: 'Please select a delivery address in order to proceed.',
        );
        return;
      }

      // 2. Check Cart Items
      final cartController = CartController.instance;
      if (cartController.cartItems.isEmpty) {
        TLoaders.warningSnackBar(
          title: 'Empty Cart',
          message: 'Add items in the cart in order to proceed.',
        );
        return;
      }

      // 3. Start Loader
      TFullScreenLoader.openLoadingDialog(
        'Processing your order...',
        SImages.pencilAnimation,
      );

      // 4. Get User Authentication ID
      final userId = AuthenticationRepository.instance.authUser?.id ?? '';

      // 5. Generate Order Model
      final order = OrderModel(
        id: UniqueKey().toString(),
        userId: userId,
        status: OrderStatus.pending,
        totalAmount: totalAmount,
        orderDate: DateTime.now(),
        paymentMethod: 'Paypal',
        address: addressController.selectedAddress.value,
        deliveryDate: DateTime.now().add(const Duration(days: 3)),
        items: cartController.cartItems.toList(),
      );

      // 6. Save Order to Database and Local Storage
      await orderRepository.saveOrder(order, userId);
      myOrders.insert(0, order);

      // 7. Clear the Cart
      cartController.clearCart();

      // 8. Stop Loader
      TFullScreenLoader.stopLoading();

      // 9. Show Success Screen
      Get.offAll(
        () => SuccessScreen(
          image: SImages.successfulPaymentIcon,
          animation: SImages.orderCompletedAnimation,
          title: 'Payment Success!',
          subTitle: 'Your item will be shipped soon!',
          onPressed: () => Get.offAll(() => const NavigationMenu()),
        ),
      );
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
