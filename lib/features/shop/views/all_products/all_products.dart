import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_store/common/widgets/appbar/appbar.dart';
import 'package:s_store/common/widgets/products/sortable/sortable_products.dart';
import 'package:s_store/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:s_store/features/shop/controllers/all_products_controller.dart';
import 'package:s_store/features/shop/models/product_model.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/utils/helpers/cloud_helper_functions.dart';

class AllProducts extends StatelessWidget {
  const AllProducts({
    super.key,
    required this.title,
    this.query,
    this.futureMethod,
  });

  final String title;
  final dynamic query;
  final Future<List<ProductModel>>? futureMethod;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllProductsController());

    return Scaffold(
      appBar: SAppBar(
        title: Text(title),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SSizes.defaultSpace),
          child: FutureBuilder<List<ProductModel>>(
            future: futureMethod ?? controller.fetchProductsByQuery(query),
            builder: (context, snapshot) {
              // Check the state of FutureBuilder snapshots
              const loader = SVerticalProductShimmer();
              final widget = TCloudHelperFunctions.checkMultiRecordState(
                snapshot: snapshot,
                loader: loader,
              );

              // Return appropriate widget based on snapshot state
              if (widget != null) return widget;

              // Products found!
              final products = snapshot.data!;

              return SSortableProducts(products: products);
            },
          ),
        ),
      ),
    );
  }
}
