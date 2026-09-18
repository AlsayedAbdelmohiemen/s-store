import 'package:get/get.dart';
import '../../../data/repositories/categories/category_repository.dart';
import '../../../data/repositories/products/product_repository.dart';
import '../../../utils/popups/loaders.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  final isLoading = false.obs;
  final _categoryRepository = Get.put(CategoryRepository());
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;
  RxString selectedCategoryId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  /// -- Load category data with optional force refresh
  Future<void> fetchCategories({bool forceRefresh = false}) async {
    try {
      // If already fetched and not forcing refresh, don't fetch again
      if (allCategories.isNotEmpty && !forceRefresh) return;

      // Show loader while loading categories
      isLoading.value = true;
      selectedCategoryId.value = '';

      // Fetch categories from data source (Supabase)
      final categories = await _categoryRepository.getAllCategories();

      // Sort categories so root categories appear in exact logical order matching Admin Panel
      categories.sort((a, b) {
        final aId = int.tryParse(a.id);
        final bId = int.tryParse(b.id);
        if (aId != null && bId != null) return aId.compareTo(bId);
        return a.name.compareTo(b.name);
      });

      // Update the categories list
      allCategories.assignAll(categories);

      // Filter featured categories (root categories with no parentId)
      final featured = allCategories
          .where((category) =>
              category.isFeatured &&
              (category.parentId.isEmpty || category.parentId == '0'))
          .toList();

      // Fallback to top root categories if none are explicitly marked featured
      if (featured.isEmpty) {
        featured.addAll(
          allCategories
              .where((c) => c.parentId.isEmpty || c.parentId == '0'),
        );
      }

      featuredCategories.assignAll(featured);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      // Remove loader
      isLoading.value = false;
    }
  }

  /// -- Get Sub Categories
  Future<List<CategoryModel>> getSubCategories(String categoryId) async {
    try {
      if (allCategories.isNotEmpty) {
        final localSubs = allCategories
            .where((c) => c.parentId == categoryId)
            .toList();
        if (localSubs.isNotEmpty) return localSubs;
      }
      final subCategories = await _categoryRepository.getSubCategories(categoryId);
      return subCategories;
    } catch (e) {
      return [];
    }
  }

  /// -- Get Category or Subcategory Products
  Future<List<ProductModel>> getCategoryProducts({required String categoryId, int limit = 4}) async {
    try {
      final products = await ProductRepository.instance.getProductsForCategory(categoryId: categoryId, limit: limit);
      return products;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }
}
