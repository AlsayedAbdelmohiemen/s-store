import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../data/repositories/user/user_repository.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../personalization/models/user_model.dart';
import '../../views/signup/verify_email.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  /// Variables
  final hidePassword = true.obs; // Observable for hiding/showing password
  final privacyPolicy = true.obs; // Observable for privacy policy acceptance
  final email = TextEditingController(); // Controller for email input
  final lastName = TextEditingController(); // Controller for last name input
  final username = TextEditingController(); // Controller for username input
  final password = TextEditingController(); // Controller for password input
  final firstName = TextEditingController(); // Controller for first name input
  final phoneNumber = TextEditingController(); // Controller for phone number input
  final dateOfBirth = TextEditingController(); // Controller for date of birth input
  final gender = 'Male'.obs; // Observable for gender ('Male' or 'Female')
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>(); // Form key for form validation

  /// Date Picker for Date of Birth
  Future<void> selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final day = picked.day.toString().padLeft(2, '0');
      final month = picked.month.toString().padLeft(2, '0');
      final year = picked.year.toString();
      dateOfBirth.text = '$day/$month/$year';
    }
  }

  /// -- SIGNUP
  void signup() async {
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
      if (!signupFormKey.currentState!.validate()) {
        return;
      }

      // 3. Privacy Policy Check
      if (!privacyPolicy.value) {
        TLoaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          message: 'In order to create account, you must read and accept the Privacy Policy & Terms of Use.',
        );
        return;
      }

      // 4. Start Loading Dialog
      TFullScreenLoader.openLoadingDialog('We are processing your information...', SImages.docerAnimation);

      // 5. Register user in Supabase Authentication & store metadata
      final userCredential = await AuthenticationRepository.instance.registerWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
        {
          'FirstName': firstName.text.trim(),
          'LastName': lastName.text.trim(),
          'Username': username.text.trim(),
          'PhoneNumber': phoneNumber.text.trim(),
          'Gender': gender.value,
          'DateOfBirth': dateOfBirth.text.trim(),
        },
      );

      // 6. Save Authenticated user data in Supabase Users table
      final newUser = UserModel(
        id: userCredential.user?.id ?? '',
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        username: username.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicture: '',
        gender: gender.value,
        dateOfBirth: dateOfBirth.text.trim(),
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      // 7. Remove Loader
      TFullScreenLoader.stopLoading();

      // 8. Show Success Message
      TLoaders.successSnackBar(
        title: 'Congratulations',
        message: 'Your account has been created! Verify email to continue.',
      );

      // 9. Move to Verify Email Screen
      Get.to(() => VerifyEmailScreen(email: email.text.trim()));
    } catch (e) {
      // Remove Loader safely
      TFullScreenLoader.stopLoading();

      // Show error to the user
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  @override
  void onClose() {
    email.dispose();
    lastName.dispose();
    username.dispose();
    password.dispose();
    firstName.dispose();
    phoneNumber.dispose();
    dateOfBirth.dispose();
    super.onClose();
  }
}
