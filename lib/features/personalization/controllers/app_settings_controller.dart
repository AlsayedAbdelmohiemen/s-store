import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../utils/popups/loaders.dart';

class AppSettingsController extends GetxController {
  static AppSettingsController get instance => Get.find();

  final _storage = GetStorage();

  /// Notification Observables
  final pushNotifications = true.obs;
  final orderUpdates = true.obs;
  final promotionalAlerts = true.obs;
  final securityAlerts = true.obs;
  final notificationSounds = true.obs;

  /// App Preferences Observables
  final geolocation = true.obs;
  final safeMode = false.obs;
  final hdImages = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    pushNotifications.value = _storage.read('SETTINGS_PUSH_NOTIFICATIONS') ?? true;
    orderUpdates.value = _storage.read('SETTINGS_ORDER_UPDATES') ?? true;
    promotionalAlerts.value = _storage.read('SETTINGS_PROMOTIONS') ?? true;
    securityAlerts.value = _storage.read('SETTINGS_SECURITY') ?? true;
    notificationSounds.value = _storage.read('SETTINGS_SOUNDS') ?? true;

    geolocation.value = _storage.read('SETTINGS_GEOLOCATION') ?? true;
    safeMode.value = _storage.read('SETTINGS_SAFE_MODE') ?? false;
    hdImages.value = _storage.read('SETTINGS_HD_IMAGES') ?? false;
  }

  void togglePushNotifications(bool value) {
    pushNotifications.value = value;
    _storage.write('SETTINGS_PUSH_NOTIFICATIONS', value);
    if (value) {
      TLoaders.successSnackBar(
        title: 'Notifications Enabled',
        message: 'You will receive real-time alerts for orders and deals.',
      );
    } else {
      TLoaders.customToast(message: 'Notifications disabled');
    }
  }

  void toggleOrderUpdates(bool value) {
    orderUpdates.value = value;
    _storage.write('SETTINGS_ORDER_UPDATES', value);
  }

  void togglePromotions(bool value) {
    promotionalAlerts.value = value;
    _storage.write('SETTINGS_PROMOTIONS', value);
  }

  void toggleSecurityAlerts(bool value) {
    securityAlerts.value = value;
    _storage.write('SETTINGS_SECURITY', value);
  }

  void toggleNotificationSounds(bool value) {
    notificationSounds.value = value;
    _storage.write('SETTINGS_SOUNDS', value);
  }

  void toggleGeolocation(bool value) {
    geolocation.value = value;
    _storage.write('SETTINGS_GEOLOCATION', value);
  }

  void toggleSafeMode(bool value) {
    safeMode.value = value;
    _storage.write('SETTINGS_SAFE_MODE', value);
  }

  void toggleHdImages(bool value) {
    hdImages.value = value;
    _storage.write('SETTINGS_HD_IMAGES', value);
  }
}
