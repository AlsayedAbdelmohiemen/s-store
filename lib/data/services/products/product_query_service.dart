import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../features/shop/controllers/category_controller.dart';
import '../../../features/shop/models/product_model.dart';

/// Service dedicated to querying products (Featured, by Category, by Brand, by Query)
/// directly from the Supabase backend linked to the Admin Panel.
class ProductQueryService {
  final SupabaseClient _supabase;

  ProductQueryService({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  /// Get limited featured products (up to 6) from Supabase
  Future<List<ProductModel>> getFeaturedProducts() async {
    try {
      final response = await _supabase
          .from('Products')
          .select()
          .eq('IsFeatured', true)
          .limit(6);

      final list = (response as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();

      if (list.isEmpty) {
        // If none marked as featured, fallback to newest products from Supabase
        final allRecent = await _supabase.from('Products').select().limit(6);
        return (allRecent as List<dynamic>)
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return list;
    } catch (_) {
      return [];
    }
  }

  /// Get all featured products from Supabase
  Future<List<ProductModel>> getAllFeaturedProducts() async {
    try {
      final response = await _supabase
          .from('Products')
          .select()
          .eq('IsFeatured', true);

      final list = (response as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();

      if (list.isEmpty) {
        final allRecent = await _supabase.from('Products').select();
        return (allRecent as List<dynamic>)
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return list;
    } catch (_) {
      return [];
    }
  }

  /// Fetch products by category ID or general query from Supabase
  Future<List<ProductModel>> fetchProductsByQuery(dynamic query) async {
    try {
      if (query is String && query.isNotEmpty) {
        final response = await _supabase
            .from('Products')
            .select()
            .eq('CategoryId', query);

        final list = (response as List<dynamic>)
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();

        return list;
      }
      return getAllFeaturedProducts();
    } catch (_) {
      return [];
    }
  }

  /// Get Products For Brand directly from Supabase
  Future<List<ProductModel>> getProductsForBrand({
    required String brandId,
    int limit = -1,
  }) async {
    try {
      final baseQuery = _supabase
          .from('Products')
          .select()
          .or('Brand->>Id.eq.$brandId,Brand->>id.eq.$brandId');
      final response = limit > 0 ? await baseQuery.limit(limit) : await baseQuery;

      final list = (response as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return list;
    } catch (_) {
      return [];
    }
  }

  /// Get Products For Category directly from Supabase (matching Admin Panel categories and subcategories)
  Future<List<ProductModel>> getProductsForCategory({
    required String categoryId,
    int limit = -1,
  }) async {
    try {
      final allCategoryIds = <String>{categoryId};

      // Dynamically include any child subcategories
      if (Get.isRegistered<CategoryController>()) {
        final children = CategoryController.instance.allCategories
            .where((c) => c.parentId == categoryId)
            .map((c) => c.id);
        allCategoryIds.addAll(children);
      }

      // Shoes category cross-reference
      if (categoryId == '6') {
        allCategoryIds.add('8');
      }

      final baseQuery = _supabase.from('Products').select();

      final filteredQuery = allCategoryIds.length == 1
          ? baseQuery.eq('CategoryId', allCategoryIds.first)
          : baseQuery.inFilter('CategoryId', allCategoryIds.toList());

      final response = limit > 0
          ? await filteredQuery.limit(limit)
          : await filteredQuery;

      final list = (response as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return list;
    } catch (_) {
      return [];
    }
  }
}
