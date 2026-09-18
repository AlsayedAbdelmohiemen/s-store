import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_store/common/widgets/appbar/appbar.dart';
import 'package:s_store/common/widgets/loaders/animation_loader.dart';
import 'package:s_store/features/shop/controllers/order_controller.dart';
import 'package:s_store/features/shop/views/orders/widgets/orders_list.dart';
import 'package:s_store/navigation_menu.dart';
import 'package:s_store/utils/constants/image_strings.dart';
import 'package:s_store/utils/constants/sizes.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());

    return Scaffold(
      /// -- AppBar
      appBar: SAppBar(
        title: Text(
          'My Orders',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchUserOrders(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(SSizes.defaultSpace),
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (controller.myOrders.isEmpty) {
                return TAnimationLoaderWidget(
                  text: 'Whoops! No Orders Yet!',
                  animation: SImages.orderCompletedAnimation,
                  showAction: true,
                  actionText: "Let's shop",
                  onActionPressed: () => Get.off(() => const NavigationMenu()),
                );
              }

              return SOrderListItems(orders: controller.myOrders);
            }),
          ),
        ),
      ),
    );
  }
}
