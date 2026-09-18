import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../../authentication/controllers/login/login_controller.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final profileLoading = false.obs;
  final imageUploading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final userRepository = Get.put(UserRepository());
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();

    // Listen to Supabase auth state changes
    _authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn ||
          data.event == AuthChangeEvent.tokenRefreshed ||
          data.event == AuthChangeEvent.userUpdated) {
        fetchUserRecord();
      } else if (data.event == AuthChangeEvent.signedOut) {
        user(UserModel.empty());
      }
    });
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    super.onClose();
  }

  /// Fetch user record
  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final fetchedUser = await userRepository.fetchUserDetails();
      if (fetchedUser.id.isNotEmpty) {
        user(fetchedUser);
      } else {
        // If user record doesn't exist yet in Users table, populate from auth metadata
        final authUser = AuthenticationRepository.instance.authUser;
        if (authUser != null) {
          final nameParts = (authUser.userMetadata?['full_name'] ?? '').toString().split(' ');
          final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
          final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
          final username = authUser.userMetadata?['name'] ?? authUser.email?.split('@')[0] ?? '';

          final fallbackUser = UserModel(
            id: authUser.id,
            firstName: firstName.isNotEmpty ? firstName : (authUser.userMetadata?['first_name'] ?? ''),
            lastName: lastName.isNotEmpty ? lastName : (authUser.userMetadata?['last_name'] ?? ''),
            username: username,
            email: authUser.email ?? '',
            phoneNumber: authUser.phone ?? '',
            profilePicture: authUser.userMetadata?['avatar_url'] ?? '',
            gender: authUser.userMetadata?['gender'] ?? '',
            dateOfBirth: authUser.userMetadata?['date_of_birth'] ?? '',
          );
          await userRepository.saveUserRecord(fallbackUser);
          user(fallbackUser);
        } else {
          user(UserModel.empty());
        }
      }
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  /// Save user record from any registration provider (e.g. Google)
  Future<void> saveUserRecord(User? authUser) async {
    try {
      if (authUser == null) return;

      // Refresh existing user record
      await fetchUserRecord();

      // If user data does not exist, save new record
      if (user.value.id.isEmpty) {
        final nameParts = (authUser.userMetadata?['full_name'] ?? '').toString().split(' ');
        final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
        final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        final username = authUser.userMetadata?['name'] ?? authUser.email?.split('@')[0] ?? '';

        final newUser = UserModel(
          id: authUser.id,
          firstName: firstName,
          lastName: lastName,
          username: username,
          email: authUser.email ?? '',
          phoneNumber: authUser.phone ?? '',
          profilePicture: authUser.userMetadata?['avatar_url'] ?? '',
        );

        await userRepository.saveUserRecord(newUser);
        user(newUser);
      }
    } catch (e) {
      TLoaders.warningSnackBar(
        title: 'Data not saved',
        message: 'Something went wrong while saving your info. You can re-save your data in your Profile.',
      );
    }
  }

  /// Upload Profile Image
  Future<void> uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 512,
        maxWidth: 512,
      );

      if (image != null) {
        imageUploading.value = true;

        // Upload Image to Supabase Storage
        final imageUrl = await userRepository.uploadImage('Users/Images/Profile', image);

        // Update User Profile Picture in Supabase Database
        Map<String, dynamic> json = {'ProfilePicture': imageUrl};
        await userRepository.updateSingleField(json);

        // Update local user state
        user.value.profilePicture = imageUrl;
        user.refresh();

        TLoaders.successSnackBar(
          title: 'Congratulations',
          message: 'Your Profile Image has been updated!',
        );
      }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Oh Snap!',
        message: 'Something went wrong: $e',
      );
    } finally {
      imageUploading.value = false;
    }
  }

  /// Show quick edit dialog for simple fields (Username, Phone Number)
  void showEditFieldDialog({
    required String title,
    required String fieldName,
    required String initialValue,
  }) {
    final textController = TextEditingController(text: initialValue);
    Get.defaultDialog(
      title: 'Update $title',
      contentPadding: const EdgeInsets.all(SSizes.md),
      content: TextFormField(
        controller: textController,
        decoration: InputDecoration(
          labelText: title,
          hintText: 'Enter new $title',
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          final newValue = textController.text.trim();
          if (newValue.isEmpty) {
            TLoaders.warningSnackBar(title: 'Empty Field', message: 'Please enter a valid $title');
            return;
          }

          Get.back(); // close dialog

          try {
            TFullScreenLoader.openLoadingDialog('Updating $title...', '');
            await userRepository.updateSingleField({fieldName: newValue});

            // Update local model
            if (fieldName == 'Username' || fieldName == 'username') {
              user.value.username = newValue;
            } else if (fieldName == 'PhoneNumber' || fieldName == 'phoneNumber') {
              user.value.phoneNumber = newValue;
            }
            user.refresh();

            TFullScreenLoader.stopLoading();
            TLoaders.successSnackBar(title: 'Updated', message: '$title updated successfully.');
          } catch (e) {
            TFullScreenLoader.stopLoading();
            TLoaders.errorSnackBar(title: 'Error', message: e.toString());
          }
        },
        child: const Text('Save'),
      ),
      cancel: OutlinedButton(
        onPressed: () => Get.back(),
        child: const Text('Cancel'),
      ),
    );
  }

  /// Update Gender Dialog
  void showEditGenderDialog(BuildContext context) {
    Get.defaultDialog(
      title: 'Select Gender',
      contentPadding: const EdgeInsets.all(SSizes.md),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.male),
            title: const Text('Male'),
            onTap: () async {
              Get.back();
              await updateGender('Male');
            },
          ),
          ListTile(
            leading: const Icon(Icons.female),
            title: const Text('Female'),
            onTap: () async {
              Get.back();
              await updateGender('Female');
            },
          ),
        ],
      ),
    );
  }

  /// Update Gender in Supabase
  Future<void> updateGender(String newGender) async {
    try {
      TFullScreenLoader.openLoadingDialog('Updating Gender...', '');
      await userRepository.updateSingleField({'Gender': newGender});
      user.value.gender = newGender;
      user.refresh();
      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(title: 'Updated', message: 'Gender updated successfully.');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  /// Select and Save Date of Birth
  Future<void> selectAndSaveDateOfBirth(BuildContext context) async {
    try {
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
        final formattedDate = '$day/$month/$year';

        TFullScreenLoader.openLoadingDialog('Updating Date of Birth...', '');
        await userRepository.updateSingleField({'DateOfBirth': formattedDate});
        user.value.dateOfBirth = formattedDate;
        user.refresh();
        TFullScreenLoader.stopLoading();
        TLoaders.successSnackBar(title: 'Updated', message: 'Date of Birth updated successfully.');
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  /// Delete Account Warning Popup
  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(SSizes.md),
      title: 'Delete Account',
      middleText:
          'Are you sure you want to delete your account permanently? This action is not reversible and all of your data will be removed permanently.',
      confirm: ElevatedButton(
        onPressed: () async {
          Get.back(); // Dismiss dialog first
          await deleteUserAccount();
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

  /// Delete User Account completely from Supabase & local caches
  Future<void> deleteUserAccount() async {
    try {
      TFullScreenLoader.openLoadingDialog(
        'Deleting your account...',
        SImages.docerAnimation,
      );

      final auth = AuthenticationRepository.instance;
      final userId = auth.authUser?.id;

      // 1. Delete user data completely from Supabase (Auth & Tables)
      if (userId != null && userId.isNotEmpty) {
        await userRepository.removeUserRecord(userId);
      }

      // 2. Clear local storage caches for this user
      final localStorage = GetStorage();
      if (userId != null && userId.isNotEmpty) {
        localStorage.remove('USER_ADDRESSES_$userId');
        localStorage.remove('USER_ORDERS_$userId');
      }
      localStorage.remove('cartItems');
      localStorage.remove('REMEMBER_ME_EMAIL');
      localStorage.remove('REMEMBER_ME_PASSWORD');

      if (Get.isRegistered<LoginController>()) {
        final loginController = LoginController.instance;
        loginController.email.clear();
        loginController.password.clear();
        loginController.rememberMe.value = false;
      }

      user.value = UserModel.empty();

      // 3. Stop Loader
      TFullScreenLoader.stopLoading();

      // 4. Show success message
      TLoaders.customToast(message: 'Account deleted successfully.');

      // 5. Logout and navigate to login
      await auth.logout();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
