import 'package:flutter/material.dart';
import '../layouts/grid_layout.dart';
import 'shimmer.dart';

class SBrandsShimmer extends StatelessWidget {
  const SBrandsShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SGridLayout(
      itemCount: itemCount,
      mainAxisExtent: 80,
      itemBuilder: (_, __) => const SShimmerEffect(width: 300, height: 80),
    );
  }
}
