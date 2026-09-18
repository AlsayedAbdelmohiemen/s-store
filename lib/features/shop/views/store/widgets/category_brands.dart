import 'package:flutter/material.dart';
import '../../../../../common/widgets/brands/brand_show_case.dart';
import '../../../../../common/widgets/shimmers/boxes_shimmer.dart';
import '../../../../../common/widgets/shimmers/list_tile_shimmer.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/cloud_helper_functions.dart';
import '../../../controllers/brand_controller.dart';
import '../../../models/category_model.dart';

class CategoryBrands extends StatelessWidget {
  const CategoryBrands({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = BrandController.instance;

    return FutureBuilder(
      future: controller.getBrandsForCategory(category.id),
      builder: (context, snapshot) {
        /// Handle Loader, No Data, or Error Message
        const loader = Column(
          children: [
            SListTileShimmer(),
            SizedBox(height: SSizes.spaceBtwItems),
            SBoxesShimmer(),
            SizedBox(height: SSizes.spaceBtwItems),
          ],
        );

        final widget = TCloudHelperFunctions.checkMultiRecordState(
          snapshot: snapshot,
          loader: loader,
        );
        if (widget != null) return widget;

        /// Record Found!
        final brands = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: brands.length,
          itemBuilder: (_, index) {
            final brand = brands[index];
            return FutureBuilder(
              future: controller.getBrandProducts(brandId: brand.id, limit: 3),
              builder: (context, snapshot) {
                /// Handle Loader, No Data, or Error Message
                final widget = TCloudHelperFunctions.checkMultiRecordState(
                  snapshot: snapshot,
                  loader: loader,
                );
                if (widget != null) return widget;

                /// Record Found!
                final products = snapshot.data!;
                final images = products.map((e) => e.thumbnail).toList();

                return SBrandShowCase(
                  brand: brand,
                  images: images,
                );
              },
            );
          },
        );
      },
    );
  }
}
