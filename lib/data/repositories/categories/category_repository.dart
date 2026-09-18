import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../features/shop/models/category_model.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class CategoryRepository extends GetxController {
  static CategoryRepository get instance => Get.find();

  final _supabase = Supabase.instance.client;

  /// Get all categories from Supabase
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final response = await _supabase.from('Categories').select();
      final list = (response as List<dynamic>)
          .map((category) => CategoryModel.fromJson(category as Map<String, dynamic>))
          .toList();
      return list;
    } catch (_) {
      return [];
    }
  }

  /// Get Sub Categories
  Future<List<CategoryModel>> getSubCategories(String categoryId) async {
    try {
      final response = await _supabase
          .from('Categories')
          .select()
          .eq('ParentId', categoryId);
      final list = (response as List<dynamic>)
          .map((category) => CategoryModel.fromJson(category as Map<String, dynamic>))
          .toList();
      return list;
    } catch (_) {
      return [];
    }
  }

  /// Upload dummy categories to Supabase
  Future<void> uploadDummyData(List<CategoryModel> categories) async {
    try {
      final list = categories.map((cat) => cat.toJson()).toList();
      await _supabase.from('Categories').upsert(list);
    } on PostgrestException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
