import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';

class ProductSearchController extends GetxController {
  static ProductSearchController get instance => Get.find();

  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxList<ProductModel> searchResults = <ProductModel>[].obs;
  final RxList<String> searchHistory = <String>[].obs;

  final _supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    // Debounce search so we don't spam requests on every single keystroke
    debounce(
      searchQuery,
      (query) => searchProducts(query),
      time: const Duration(milliseconds: 300),
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  /// Search products in Supabase with fallback to local dummy data
  Future<void> searchProducts(String query) async {
    final cleanQuery = query.trim();

    if (cleanQuery.isEmpty) {
      searchResults.clear();
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;

      // 1. Try remote Supabase search by title or description
      try {
        final response = await _supabase
            .from('Products')
            .select()
            .or('Title.ilike.%$cleanQuery%,Description.ilike.%$cleanQuery%')
            .limit(20)
            .timeout(const Duration(seconds: 4));

        final remoteList = (response as List<dynamic>)
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();

        searchResults.assignAll(remoteList);
        if (remoteList.isNotEmpty) {
          _addToHistory(cleanQuery);
        }
        return;
      } catch (_) {
        searchResults.clear();
      }
    } catch (_) {
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Select a search tag or recent keyword
  void applySearchTag(String tag) {
    searchController.text = tag;
    searchQuery.value = tag;
    searchProducts(tag);
  }

  /// Clear the active search query and results
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    searchResults.clear();
    isLoading.value = false;
  }

  /// Save query to history list
  void _addToHistory(String query) {
    if (!searchHistory.contains(query)) {
      searchHistory.insert(0, query);
      if (searchHistory.length > 8) {
        searchHistory.removeLast();
      }
    }
  }

  /// Remove single item from history
  void removeFromHistory(String query) {
    searchHistory.remove(query);
  }

  /// Clear entire search history
  void clearHistory() {
    searchHistory.clear();
  }
}
