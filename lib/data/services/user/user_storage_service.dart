import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

/// Service dedicated to handling user image and asset uploads to Supabase Storage.
class UserStorageService {
  final SupabaseClient _supabase;

  UserStorageService({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  /// Upload any Image to Supabase Storage Bucket.
  Future<String> uploadImage(String path, XFile image) async {
    try {
      final imageBytes = await image.readAsBytes();
      final fileExt = image.name.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final fullPath = '$path/$fileName';

      await _supabase.storage.from('Users').uploadBinary(
            fullPath,
            imageBytes,
            fileOptions: FileOptions(contentType: 'image/$fileExt'),
          );

      final imageUrl = _supabase.storage.from('Users').getPublicUrl(fullPath);
      return imageUrl;
    } on StorageException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (_) {
      throw 'Something went wrong. Please try again';
    }
  }
}
