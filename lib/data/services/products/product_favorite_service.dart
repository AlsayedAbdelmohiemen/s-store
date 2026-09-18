import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../features/shop/models/product_model.dart';

/// Service dedicated to retrieving favorited products.
class ProductFavoriteService {
  final SupabaseClient _supabase;

  ProductFavoriteService({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  /// Get Favorite Products by their IDs
  Future<List<ProductModel>> getFavouriteProducts(
    List<String> productIds,
  ) async {
    try {
      if (productIds.isEmpty) return [];

      final validIds = productIds.where((id) => id.isNotEmpty).toList();
      if (validIds.isEmpty) return [];

      List<ProductModel> results = [];

      // 1. Try querying Supabase with 'id'
      try {
        final response = await _supabase
            .from('Products')
            .select()
            .filter('id', 'in', validIds);

        final list = (response as List<dynamic>)
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
        results.addAll(list);
      } catch (_) {
        // Fallback: Try querying Supabase with 'Id'
        try {
          final response = await _supabase
              .from('Products')
              .select()
              .filter('Id', 'in', validIds);

          final list = (response as List<dynamic>)
              .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .toList();
          results.addAll(list);
        } catch (_) {}
      }

      return results;
    } catch (_) {
      return [];
    }
  }
}
