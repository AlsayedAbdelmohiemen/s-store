import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_store/common/widgets/appbar/appbar.dart';
import 'package:s_store/common/widgets/brands/brand_card.dart';
import 'package:s_store/common/widgets/layouts/grid_layout.dart';
import 'package:s_store/common/widgets/shimmers/brands_shimmer.dart';
import 'package:s_store/common/widgets/texts/section_heading.dart';
import 'package:s_store/features/shop/controllers/brand_controller.dart';
import 'package:s_store/features/shop/views/brand/brand_products.dart';
import 'package:s_store/utils/constants/sizes.dart';

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brandController = BrandController.instance;

    return Scaffold(
      appBar: const SAppBar(
        title: Text('Brand'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SSizes.defaultSpace),
          child: Column(
            children: [
              /// Heading
              const SSectionHeading(
                title: 'Brands',
                showActionsButton: false,
              ),
              const SizedBox(height: SSizes.spaceBtwItems),

              /// Brands Grid
              Obx(() {
                if (brandController.isLoading.value) {
                  return const SBrandsShimmer();
                }

                if (brandController.allBrands.isEmpty) {
                  return Center(
                    child: Text(
                      'No Data Found!',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }

                return SGridLayout(
                  itemCount: brandController.allBrands.length,
                  mainAxisExtent: 80,
                  itemBuilder: (context, index) {
                    final brand = brandController.allBrands[index];
                    return SBrandCard(
                      showBorder: true,
                      brand: brand,
                      onTap: () => Get.to(() => BrandProducts(brand: brand)),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
