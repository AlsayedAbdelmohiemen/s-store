import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/repositories/products/product_repository.dart';
import '../../../utils/popups/loaders.dart';
import '../models/product_model.dart';

class FavouritesController extends GetxController {
  static FavouritesController get instance => Get.isRegistered<FavouritesController>()
      ? Get.find<FavouritesController>()
      : Get.put(FavouritesController());

  /// Variables
  final favorites = <String, bool>{}.obs;
  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    initFavorites();
  }

  /// Initialize favorites by reading from local storage
  void initFavorites() {
    try {
      final storedData = _storage.read('favorites');
      if (storedData != null) {
        final Map<String, dynamic> storedFavorites;
        if (storedData is String) {
          storedFavorites = jsonDecode(storedData) as Map<String, dynamic>;
        } else if (storedData is Map) {
          storedFavorites = Map<String, dynamic>.from(storedData);
        } else {
          storedFavorites = {};
        }
        favorites.assignAll(
          storedFavorites.map(
            (key, value) => MapEntry(key.toString(), value == true || value == 'true' || value == 1),
          ),
        );
      }
    } catch (_) {
      favorites.clear();
    }
  }

  /// Check if product is in wishlist
  bool isFavourite(String productId) {
    return favorites[productId] == true;
  }

  /// Toggle product favorite status
  void toggleFavoriteProduct(String productId) {
    if (productId.isEmpty) return;

    if (favorites[productId] != true) {
      favorites[productId] = true;
      saveFavoritesToStorage();
      favorites.refresh();
      TLoaders.customToast(message: 'Product has been added to the Wishlist.');
    } else {
      favorites.remove(productId);
      saveFavoritesToStorage();
      favorites.refresh();
      TLoaders.customToast(message: 'Product has been removed from the Wishlist.');
    }
  }

  /// Save favorites to local storage
  void saveFavoritesToStorage() {
    try {
      final encodedFavorites = jsonEncode(favorites);
      _storage.write('favorites', encodedFavorites);
    } catch (_) {}
  }

  /// Fetch list of favorite product models
  Future<List<ProductModel>> favoriteProducts() async {
    final activeIds = favorites.entries
        .where((entry) => entry.value == true && entry.key.isNotEmpty)
        .map((entry) => entry.key)
        .toList();

    if (activeIds.isEmpty) return [];
    return await ProductRepository.instance.getFavouriteProducts(activeIds);
  }
}
