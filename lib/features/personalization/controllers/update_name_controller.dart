import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import 'user_controller.dart';

/// Controller to manage user name update
class UpdateNameController extends GetxController {
  static UpdateNameController get instance => Get.find();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userController = UserController.instance;
  final userRepository = UserRepository.instance;
  GlobalKey<FormState> updateUserNameFormKey = GlobalKey<FormState>();

  /// Init user data when Home Screen appears
  @override
  void onInit() {
    initializeNames();
    super.onInit();
  }

  /// Fetch user data
  Future<void> initializeNames() async {
    firstName.text = userController.user.value.firstName;
    lastName.text = userController.user.value.lastName;
  }

  Future<void> updateUserName() async {
    try {
      // 1. Start Loading
      TFullScreenLoader.openLoadingDialog('We are updating your information...', '');

      // 2. Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(title: 'No Internet Connection', message: 'Please check your connection.');
        return;
      }

      // 3. Form Validation
      if (!updateUserNameFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // 4. Update user's first & last name in Supabase Users table
      Map<String, dynamic> name = {
        'FirstName': firstName.text.trim(),
        'LastName': lastName.text.trim(),
      };
      await userRepository.updateSingleField(name);

      // 5. Update the Rx User value
      userController.user.value.firstName = firstName.text.trim();
      userController.user.value.lastName = lastName.text.trim();
      userController.user.refresh();

      // 6. Remove Loader
      TFullScreenLoader.stopLoading();

      // 7. Show Success Message
      TLoaders.successSnackBar(title: 'Congratulations', message: 'Your Name has been updated.');

      // 8. Move back to previous screen
      Get.back();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  @override
  void onClose() {
    firstName.dispose();
    lastName.dispose();
    super.onClose();
  }
}
