import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/app_settings_controller.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppSettingsController());
    final dark = SHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: const SAppBar(
        title: Text('Notification Settings'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Master Switch Card
              Obx(
                () => Container(
                  padding: const EdgeInsets.all(SSizes.md),
                  decoration: BoxDecoration(
                    color: dark ? SColors.darkContainer : SColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: dark ? SColors.darkerGrey.withValues(alpha: 0.3) : SColors.borderSecondary,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: SColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Iconsax.notification_bing, color: SColors.primary, size: 24),
                      ),
                      const SizedBox(width: SSizes.spaceBtwItems),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Push Notifications',
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Enable or disable all notifications',
                              style: Theme.of(context).textTheme.labelMedium!.copyWith(color: SColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: controller.pushNotifications.value,
                        activeThumbColor: SColors.primary,
                        onChanged: (val) => controller.togglePushNotifications(val),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: SSizes.spaceBtwSections),

              /// Notification Types
              const SSectionHeading(
                title: 'Notification Preferences',
                showActionsButton: false,
              ),
              const SizedBox(height: SSizes.spaceBtwItems),

              /// Detailed switches
              Obx(
                () => Container(
                  decoration: BoxDecoration(
                    color: dark ? SColors.darkContainer : SColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: dark ? SColors.darkerGrey.withValues(alpha: 0.3) : SColors.borderSecondary,
                    ),
                  ),
                  child: Column(
                    children: [
                      _NotificationItem(
                        icon: Iconsax.box_tick,
                        title: 'Order Status & Shipping',
                        subTitle: 'Updates on your order delivery and tracking',
                        value: controller.orderUpdates.value && controller.pushNotifications.value,
                        enabled: controller.pushNotifications.value,
                        onChanged: (val) => controller.toggleOrderUpdates(val),
                      ),
                      const Divider(height: 1),
                      _NotificationItem(
                        icon: Iconsax.discount_shape,
                        title: 'Promotions & Discounts',
                        subTitle: 'Special sales, coupons, and flash deals',
                        value: controller.promotionalAlerts.value && controller.pushNotifications.value,
                        enabled: controller.pushNotifications.value,
                        onChanged: (val) => controller.togglePromotions(val),
                      ),
                      const Divider(height: 1),
                      _NotificationItem(
                        icon: Iconsax.security_card,
                        title: 'Security & Account',
                        subTitle: 'Alerts regarding password changes and login',
                        value: controller.securityAlerts.value && controller.pushNotifications.value,
                        enabled: controller.pushNotifications.value,
                        onChanged: (val) => controller.toggleSecurityAlerts(val),
                      ),
                      const Divider(height: 1),
                      _NotificationItem(
                        icon: Iconsax.volume_high,
                        title: 'Notification Sounds',
                        subTitle: 'Play sound when notifications arrive',
                        value: controller.notificationSounds.value && controller.pushNotifications.value,
                        enabled: controller.pushNotifications.value,
                        onChanged: (val) => controller.toggleNotificationSounds(val),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subTitle;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: enabled ? SColors.primary : SColors.darkGrey, size: 22),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(subTitle, style: Theme.of(context).textTheme.labelMedium!.copyWith(color: SColors.textSecondary)),
      trailing: Switch(
        value: value,
        activeThumbColor: SColors.primary,
        onChanged: enabled ? onChanged : null,
      ),
    );
  }
}
