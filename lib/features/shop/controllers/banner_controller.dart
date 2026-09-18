import 'package:get/get.dart';
import '../../../data/repositories/banners/banner_repository.dart';
import '../../../utils/popups/loaders.dart';
import '../models/banner_model.dart';

class BannerController extends GetxController {
  static BannerController get instance => Get.find();

  final carousalCurrentIndex = 0.obs;
  final isLoading = false.obs;
  final RxList<BannerModel> banners = <BannerModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
  }

  /// Update Page Navigational Dots
  void updatePageIndicator(int index) {
    carousalCurrentIndex.value = index;
  }

  /// Fetch Banners from Supabase Repository
  Future<void> fetchBanners() async {
    try {
      // Show loader while loading banners
      isLoading.value = true;

      // Fetch Banners
      final bannerRepo = Get.put(BannerRepository());
      final fetchedBanners = await bannerRepo.getAllBanners();

      // Assign Banners
      banners.assignAll(fetchedBanners);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      // Remove loader
      isLoading.value = false;
    }
  }
}
