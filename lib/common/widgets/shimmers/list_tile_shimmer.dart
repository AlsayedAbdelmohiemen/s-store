import 'package:flutter/material.dart';
import '../../../utils/constants/sizes.dart';
import 'shimmer.dart';

class SListTileShimmer extends StatelessWidget {
  const SListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SShimmerEffect(width: 50, height: 50, radius: 50),
        SizedBox(width: SSizes.spaceBtwItems),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SShimmerEffect(width: 100, height: 15),
            SizedBox(height: SSizes.spaceBtwItems / 2),
            SShimmerEffect(width: 80, height: 12),
          ],
        ),
      ],
    );
  }
}
