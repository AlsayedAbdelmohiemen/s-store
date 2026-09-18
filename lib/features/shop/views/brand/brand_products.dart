import 'package:flutter/material.dart';
import 'package:s_store/common/widgets/appbar/appbar.dart';
import 'package:s_store/common/widgets/brands/brand_card.dart';
import 'package:s_store/common/widgets/products/sortable/sortable_products.dart';
import 'package:s_store/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:s_store/features/shop/controllers/brand_controller.dart';
import 'package:s_store/features/shop/models/brand_model.dart';
import 'package:s_store/features/shop/models/product_model.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/utils/helpers/cloud_helper_functions.dart';

class BrandProducts extends StatelessWidget {
  const BrandProducts({super.key, required this.brand});

  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    final controller = BrandController.instance;
    return Scaffold(
      appBar: SAppBar(
        title: Text(brand.name),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SSizes.defaultSpace),
          child: Column(
            children: [
              /// Brand Detail
              SBrandCard(showBorder: true, brand: brand),
              const SizedBox(height: SSizes.spaceBtwSections),

              /// Products for this brand
              FutureBuilder<List<ProductModel>>(
                future: controller.getBrandProducts(brandId: brand.id),
                builder: (context, snapshot) {
                  /// Handle Loader, No Data, or Error Message
                  const loader = SVerticalProductShimmer();
                  final widget = TCloudHelperFunctions.checkMultiRecordState(
                    snapshot: snapshot,
                    loader: loader,
                  );
                  if (widget != null) return widget;

                  /// Record Found!
                  final brandProducts = snapshot.data!;
                  return SSortableProducts(products: brandProducts);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

