import 'package:get/get.dart';
import '../../../data/repositories/products/product_repository.dart';
import '../../../utils/popups/loaders.dart';
import '../models/product_model.dart';

class AllProductsController extends GetxController {
  static AllProductsController get instance => Get.find();

  final repository = ProductRepository.instance;
  final RxString selectedSortOption = 'Name'.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;

  /// Fetch products using query
  Future<List<ProductModel>> fetchProductsByQuery(dynamic query) async {
    try {
      final products = await repository.fetchProductsByQuery(query);
      return products;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  /// Assign products and apply initial sorting
  void assignProducts(List<ProductModel> products) {
    this.products.assignAll(products);
    sortProducts('Name');
  }

  /// Sort products based on selected option
  void sortProducts(String sortOption) {
    selectedSortOption.value = sortOption;

    switch (sortOption) {
      case 'Name':
        products.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case 'Higher Price':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Lower Price':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Newest':
        products.sort((a, b) => (b.date ?? DateTime(0)).compareTo(a.date ?? DateTime(0)));
        break;
      case 'Sale':
        products.sort((a, b) {
          if (b.salePrice > 0 && a.salePrice <= 0) return -1;
          if (a.salePrice > 0 && b.salePrice <= 0) return 1;
          if (b.salePrice > 0 && a.salePrice > 0) {
            return b.salePrice.compareTo(a.salePrice);
          }
          return 0;
        });
        break;
      case 'Popularity':
        products.sort((a, b) => (b.isFeatured == true ? 1 : 0).compareTo(a.isFeatured == true ? 1 : 0));
        break;
      default:
        products.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    }
  }
}
