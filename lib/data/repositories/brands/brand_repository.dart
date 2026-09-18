import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../features/shop/controllers/category_controller.dart';
import '../../../features/shop/models/brand_model.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class BrandRepository extends GetxController {
  static BrandRepository get instance => Get.find();

  final _supabase = Supabase.instance.client;

  /// Get all brands
  Future<List<BrandModel>> getAllBrands() async {
    try {
      final response = await _supabase.from('Brands').select();
      final list = (response as List<dynamic>)
          .map((e) => BrandModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return list;
    } catch (e) {
      return [];
    }
  }

  /// Get Brands For Category
  Future<List<BrandModel>> getBrandsForCategory(String categoryId) async {
    try {
      // Collect categoryId and all its child subcategories
      final allCategoryIds = <String>{categoryId};
      if (Get.isRegistered<CategoryController>()) {
        final children = CategoryController.instance.allCategories
            .where((c) => c.parentId == categoryId)
            .map((c) => c.id);
        allCategoryIds.addAll(children);
      }
      if (categoryId == '6') {
        allCategoryIds.add('8'); // Shoes / Sport Shoes cross-reference
      }

      // 1. Try querying BrandCategories table
      try {
        final response = await _supabase
            .from('BrandCategories')
            .select('brandId, categoryId')
            .inFilter('categoryId', allCategoryIds.toList());

        final brandIds = (response as List<dynamic>)
            .map((e) => (e['brandId'] ?? e['BrandId'] ?? '').toString())
            .where((id) => id.isNotEmpty)
            .toSet()
            .toList();

        if (brandIds.isNotEmpty) {
          final brandsResponse = await _supabase
              .from('Brands')
              .select()
              .inFilter('Id', brandIds);

          final list = (brandsResponse as List<dynamic>)
              .map((e) => BrandModel.fromJson(e as Map<String, dynamic>))
              .toList();

          if (list.isNotEmpty) return list;
        }
      } catch (_) {}

      // 2. Query products belonging to this category and all its child subcategories
      final productsResponse = allCategoryIds.length == 1
          ? await _supabase
              .from('Products')
              .select('Brand')
              .eq('CategoryId', allCategoryIds.first)
          : await _supabase
              .from('Products')
              .select('Brand')
              .inFilter('CategoryId', allCategoryIds.toList());

      final Map<String, BrandModel> brandsMap = {};
      for (var item in (productsResponse as List<dynamic>)) {
        if (item['Brand'] != null && item['Brand'] is Map<String, dynamic>) {
          final b = BrandModel.fromJson(Map<String, dynamic>.from(item['Brand']));
          if (b.id.isNotEmpty && b.name.isNotEmpty) {
            brandsMap[b.id] = b;
          }
        }
      }

      return brandsMap.values.toList();
    } catch (e) {
      return [];
    }
  }

  /// Upload dummy brands to Supabase
  Future<void> uploadDummyData(List<BrandModel> brands) async {
    try {
      final list = brands.map((e) => e.toJson()).toList();
      await _supabase.from('Brands').upsert(list);
    } on PostgrestException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (e) {
      throw 'Something went wrong: $e';
    }
  }
}
