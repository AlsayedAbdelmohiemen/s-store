import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_store/features/shop/controllers/category_controller.dart';
import 'package:s_store/features/shop/views/sub_category/sub_categories.dart';

import '../../../../../common/widgets/image_text_widgets/vertical_image_text.dart';
import '../../../../../common/widgets/shimmers/category_shimmer.dart';
import '../../../../../utils/constants/sizes.dart';

class SHomeCategories extends StatelessWidget {
  const SHomeCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());

    return Obx(() {
      if (categoryController.isLoading.value) return const SCategoryShimmer();

      if (categoryController.featuredCategories.isEmpty) {
        return Center(
          child: Text(
            'No Data Found!',
            style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white),
          ),
        );
      }

      return SizedBox(
        height: 96,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: categoryController.featuredCategories.length,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: SSizes.defaultSpace),
          itemBuilder: (_, index) {
            final category = categoryController.featuredCategories[index];
            return SVerticalImageText(
              title: category.name,
              image: category.image,
              isNetworkImage: category.image.startsWith('http'),
              isSelected: categoryController.selectedCategoryId.value == category.id,
              onTap: () async {
                categoryController.selectedCategoryId.value = category.id;
                await Get.to(() => SubCategoriesScreen(category: category));
                categoryController.selectedCategoryId.value = '';
              },
            );
          },
        ),
      );
    });
  }
}
