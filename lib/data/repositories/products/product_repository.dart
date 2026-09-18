import 'package:get/get.dart';
import '../../../features/shop/models/product_model.dart';
import '../../services/products/product_favorite_service.dart';
import '../../services/products/product_query_service.dart';
import '../../services/products/product_seeding_service.dart';

/// Central Facade for product operations.
/// Coordinates product queries, favorites, and database seeding via dedicated services:
/// - [ProductQueryService]: Featured, category, and brand product queries.
/// - [ProductFavoriteService]: Favorite products retrieval.
/// - [ProductSeedingService]: Initial dummy/sample data seeding.
class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.isRegistered<ProductRepository>()
      ? Get.find<ProductRepository>()
      : Get.put(ProductRepository());

  final ProductQueryService _queryService = ProductQueryService();
  final ProductFavoriteService _favoriteService = ProductFavoriteService();
  final ProductSeedingService _seedingService = ProductSeedingService();

  /// Get limited featured products
  Future<List<ProductModel>> getFeaturedProducts() =>
      _queryService.getFeaturedProducts();

  /// Get all featured products
  Future<List<ProductModel>> getAllFeaturedProducts() =>
      _queryService.getAllFeaturedProducts();

  /// Fetch products by query
  Future<List<ProductModel>> fetchProductsByQuery(dynamic query) =>
      _queryService.fetchProductsByQuery(query);

  /// Get Products For Brand
  Future<List<ProductModel>> getProductsForBrand({
    required String brandId,
    int limit = -1,
  }) =>
      _queryService.getProductsForBrand(brandId: brandId, limit: limit);

  /// Get Products For Category
  Future<List<ProductModel>> getProductsForCategory({
    required String categoryId,
    int limit = 4,
  }) =>
      _queryService.getProductsForCategory(
        categoryId: categoryId,
        limit: limit,
      );

  /// Get Favorite Products
  Future<List<ProductModel>> getFavouriteProducts(List<String> productIds) =>
      _favoriteService.getFavouriteProducts(productIds);

  /// Upload dummy products to Supabase
  Future<void> uploadDummyData(List<ProductModel> products) =>
      _seedingService.uploadDummyData(products);
}
