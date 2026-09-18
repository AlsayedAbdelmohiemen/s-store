import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:s_store/common/widgets/appbar/appbar.dart';
import 'package:s_store/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:s_store/common/widgets/list_tiles/settings_menu_tile.dart';
import 'package:s_store/common/widgets/list_tiles/user_profile_tile.dart';
import 'package:s_store/common/widgets/texts/section_heading.dart';
import 'package:s_store/features/shop/views/cart/cart.dart';
import 'package:s_store/features/shop/views/orders/order.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/data/repositories/authentication/authentication_repository.dart';
import '../../controllers/app_settings_controller.dart';
import '../address/user_address.dart';
import '../notifications/notification_settings_screen.dart';
import '../profile/user_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.put(AppSettingsController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// -- Header
            SPrimaryHeaderContainer(
              child: Column(
                children: [
                  /// AppBar
                  SAppBar(
                    title: Text(
                      'Account',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .apply(color: SColors.white),
                    ),
                  ),

                  /// User Profile Card
                  SUserProfileTile(
                      onPressed: () => Get.to(() => const UserProfileScreen())),
                  const SizedBox(height: SSizes.spaceBtwSections),
                ],
              ),
            ),

            /// -- Body
            Padding(
              padding: const EdgeInsets.all(SSizes.defaultSpace),
              child: Column(
                children: [
                  /// -- Account Settings
                  const SSectionHeading(
                    title: 'Account Settings',
                    showActionsButton: false,
                  ),
                  const SizedBox(height: SSizes.spaceBtwItems),

                  SSettingsMenuTile(
                    icon: Iconsax.safe_home,
                    title: 'My Addresses',
                    subTitle: 'Set shopping delivery address',
                    onTap: () => Get.to(() => const UserAddressScreen()),
                  ),
                  SSettingsMenuTile(
                    icon: Iconsax.shopping_cart,
                    title: 'My Cart',
                    subTitle: 'Add, remove products and move to checkout',
                    onTap: () => Get.to(() => const CartScreen()),
                  ),
                  SSettingsMenuTile(
                    icon: Iconsax.bag_tick,
                    title: 'My Orders',
                    subTitle: 'In-progress and Completed Orders',
                    onTap: () => Get.to(() => const OrderScreen()),
                  ),
                  SSettingsMenuTile(
                    icon: Iconsax.bank,
                    title: 'Bank Account',
                    subTitle: 'Withdraw balance to registered bank account',
                    onTap: () {},
                  ),
                  SSettingsMenuTile(
                    icon: Iconsax.discount_shape,
                    title: 'My Coupons',
                    subTitle: 'List of all the discounted coupons',
                    onTap: () {},
                  ),
                  SSettingsMenuTile(
                    icon: Iconsax.notification,
                    title: 'Notifications',
                    subTitle: 'Manage alerts, sounds & preferences',
                    trailing: const Icon(Iconsax.arrow_right_34, size: 18),
                    onTap: () => Get.to(() => const NotificationSettingsScreen()),
                  ),
                  SSettingsMenuTile(
                    icon: Iconsax.security_card,
                    title: 'Account Privacy',
                    subTitle: 'Manage data usage and connected accounts',
                    onTap: () {},
                  ),

                  /// -- App Settings
                  const SizedBox(height: SSizes.spaceBtwSections),
                  const SSectionHeading(
                    title: 'App Settings',
                    showActionsButton: false,
                  ),
                  const SizedBox(height: SSizes.spaceBtwItems),

                  /// Push Notifications Quick Switch
                  Obx(
                    () => SSettingsMenuTile(
                      icon: Iconsax.notification_bing,
                      title: 'Push Notifications',
                      subTitle: 'Receive alerts on orders, discounts & deals',
                      trailing: Switch(
                        value: settingsController.pushNotifications.value,
                        activeThumbColor: SColors.primary,
                        onChanged: (value) => settingsController.togglePushNotifications(value),
                      ),
                    ),
                  ),

                  Obx(
                    () => SSettingsMenuTile(
                      icon: Iconsax.location,
                      title: 'Geolocation',
                      subTitle: 'Set recommendation based on location',
                      trailing: Switch(
                        value: settingsController.geolocation.value,
                        activeThumbColor: SColors.primary,
                        onChanged: (value) => settingsController.toggleGeolocation(value),
                      ),
                    ),
                  ),


                  /// -- Logout Button
                  const SizedBox(height: SSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => AuthenticationRepository.instance.logout(),
                      child: const Text('Logout'),
                    ),
                  ),
                  const SizedBox(height: SSizes.spaceBtwSections * 2.5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
