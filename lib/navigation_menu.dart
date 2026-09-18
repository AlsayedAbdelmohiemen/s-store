import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:s_store/features/personalization/controllers/user_controller.dart';
import 'package:s_store/features/personalization/screens/settings/settings.dart';
import 'package:s_store/features/shop/controllers/favourites_controller.dart';
import 'package:s_store/features/shop/views/store/store.dart';
import 'package:s_store/features/shop/views/wishlist/views/wishlist_screen.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/helpers/helper_functions.dart';

import 'features/shop/views/home/home.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    Get.put(UserController());
    Get.put(FavouritesController());
    final darkMode = SHelperFunctions.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          backgroundColor: darkMode ? SColors.black : Colors.white,
          indicatorColor: darkMode
              ? SColors.white.withValues(alpha: 0.1)
              : SColors.black.withValues(alpha: 0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: "Home"),
            NavigationDestination(icon: Icon(Iconsax.shop), label: "Shop"),
            NavigationDestination(icon: Icon(Iconsax.heart), label: "Wishlist"),
            NavigationDestination(icon: Icon(Iconsax.user), label: "Profile"),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    const HomeScreen(),
    const StoreScreen(),
    const WishListScreen(),
    const SettingsScreen(),
  ];
}
