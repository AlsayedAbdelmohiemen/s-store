import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../utils/logging/logger.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../data/repositories/user/user_repository.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../../personalization/models/user_model.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  /// Variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    refreshSavedCredentials();
  }

  /// Reload / refresh saved credentials from local storage
  void refreshSavedCredentials() {
    final savedEmail = localStorage.read('REMEMBER_ME_EMAIL');
    final savedPassword = localStorage.read('REMEMBER_ME_PASSWORD');
    if (savedEmail != null && savedEmail.toString().isNotEmpty) {
      email.text = savedEmail.toString();
      rememberMe.value = true;
    } else {
      email.clear();
      rememberMe.value = false;
    }
    if (savedPassword != null && savedPassword.toString().isNotEmpty) {
      password.text = savedPassword.toString();
    } else {
      password.clear();
    }
  }

  /// -- Email and Password Sign In
  Future<void> emailAndPasswordSignIn() async {
    try {
      // 1. Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TLoaders.warningSnackBar(
          title: 'No Internet Connection',
          message: 'Please check your internet connection and try again.',
        );
        return;
      }

      // 2. Form Validation
      if (!loginFormKey.currentState!.validate()) {
        return;
      }

      // 3. Save Data if Remember Me is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      } else {
        localStorage.remove('REMEMBER_ME_EMAIL');
        localStorage.remove('REMEMBER_ME_PASSWORD');
      }

      // 4. Start Loading Dialog
      TFullScreenLoader.openLoadingDialog('Logging you in...', SImages.docerAnimation);

      // 5. Login user using Supabase Authentication
      await AuthenticationRepository.instance.loginWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
      );

      // Fetch user profile data
      if (Get.isRegistered<UserController>()) {
        await UserController.instance.fetchUserRecord();
      }

      // 6. Remove Loader
      TFullScreenLoader.stopLoading();

      // 7. Redirect user
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// -- Google Sign In Authentication
  Future<void> googleSignIn() async {
    try {
      // 1. Start Loading Dialog
      TFullScreenLoader.openLoadingDialog('Logging you in...', SImages.docerAnimation);

      // 2. Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(
          title: 'No Internet Connection',
          message: 'Please check your internet connection and try again.',
        );
        return;
      }

      // 3. Google Authentication
      final userCredentials = await AuthenticationRepository.instance.signInWithGoogle();

      // 4. Save User Record in Supabase database
      final user = userCredentials.user;
      if (user != null) {
        final fullName = user.userMetadata?['full_name'] ?? user.userMetadata?['name'] ?? '';
        final nameParts = UserModel.nameParts(fullName.toString());
        final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
        final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        final username = UserModel.generateUsername('$firstName $lastName');

        final newUser = UserModel(
          id: user.id,
          firstName: firstName,
          lastName: lastName,
          username: username,
          email: user.email ?? '',
          phoneNumber: user.phone ?? '',
          profilePicture: user.userMetadata?['avatar_url'] ?? '',
        );

        final userRepository = Get.put(UserRepository());
        await userRepository.saveUserRecord(newUser);

        if (Get.isRegistered<UserController>()) {
          await UserController.instance.fetchUserRecord();
        }
      }

      // 5. Remove Loader
      TFullScreenLoader.stopLoading();

      // 6. Redirect User
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoggerHelper.error('Google Sign-In Error: $e');
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// -- Facebook Sign In Authentication
  Future<void> facebookSignIn() async {
    try {
      // 1. Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TLoaders.warningSnackBar(
          title: 'No Internet Connection',
          message: 'Please check your internet connection and try again.',
        );
        return;
      }

      // 2. Start Loading Dialog
      TFullScreenLoader.openLoadingDialog('Connecting to Facebook...', SImages.docerAnimation);

      // 3. Initiate Facebook OAuth flow via Supabase
      final launched = await AuthenticationRepository.instance.signInWithFacebook();

      // 4. Remove Loader once browser / auth flow launches
      TFullScreenLoader.stopLoading();

      if (!launched) {
        TLoaders.errorSnackBar(
          title: 'Sign In Failed',
          message: 'Could not launch Facebook authentication.',
        );
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoggerHelper.error('Facebook Sign-In Error: $e');
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
