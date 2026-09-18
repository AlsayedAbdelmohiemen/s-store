import 'package:flutter/material.dart';
import '../../../utils/constants/sizes.dart';
import 'shimmer.dart';

class SHorizontalProductShimmer extends StatelessWidget {
  const SHorizontalProductShimmer({
    super.key,
    this.itemCount = 4,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: SSizes.spaceBtwSections),
      height: 120,
      child: ListView.separated(
        itemCount: itemCount,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        separatorBuilder: (context, index) => const SizedBox(width: SSizes.spaceBtwItems),
        itemBuilder: (context, index) => const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Image
            SShimmerEffect(width: 120, height: 120),
            SizedBox(width: SSizes.spaceBtwItems),

            /// Text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: SSizes.spaceBtwItems / 2),
                SShimmerEffect(width: 160, height: 15),
                SizedBox(height: SSizes.spaceBtwItems / 2),
                SShimmerEffect(width: 110, height: 15),
                SizedBox(height: SSizes.spaceBtwItems / 2),
                SShimmerEffect(width: 80, height: 15),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
