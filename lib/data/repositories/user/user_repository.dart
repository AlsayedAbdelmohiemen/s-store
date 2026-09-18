import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../features/personalization/models/user_model.dart';
import '../../services/user/user_data_service.dart';
import '../../services/user/user_storage_service.dart';
import '../authentication/authentication_repository.dart';

/// Central Facade for user-related operations.
/// Coordinates data persistence via [UserDataService] and asset storage via [UserStorageService].
class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final UserDataService _dataService = UserDataService();
  final UserStorageService _storageService = UserStorageService();

  /// Function to save user data to Supabase database (Create / Upsert).
  Future<void> saveUserRecord(UserModel user) =>
      _dataService.saveUserRecord(user);

  /// Function to fetch user details based on authenticated user ID (Read).
  Future<UserModel> fetchUserDetails() async {
    final userId = AuthenticationRepository.instance.authUser?.id ?? '';
    return _dataService.fetchUserDetails(userId);
  }

  /// Function to update user data in Supabase (Update).
  Future<void> updateUserDetails(UserModel updatedUser) =>
      _dataService.updateUserDetails(updatedUser);

  /// Update any specific field in Users table.
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    final userId = AuthenticationRepository.instance.authUser?.id ?? '';
    return _dataService.updateSingleField(userId, json);
  }

  /// Function to remove user data from Supabase (Delete).
  Future<void> removeUserRecord(String userId) =>
      _dataService.removeUserRecord(userId);

  /// Upload any Image to Supabase Storage Bucket.
  Future<String> uploadImage(String path, XFile image) =>
      _storageService.uploadImage(path, image);
}
