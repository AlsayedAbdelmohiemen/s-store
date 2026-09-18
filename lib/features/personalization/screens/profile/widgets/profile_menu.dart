import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../../utils/constants/sizes.dart';

class SProfileMenu extends StatelessWidget {
  const SProfileMenu({
    super.key,
    required this.title,
    required this.value,
    this.onPressed,
    this.icon = Iconsax.arrow_right_34,
    this.isLoading = false,
  });

  final String title;
  final String value;
  final VoidCallback? onPressed;
  final IconData icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: SSizes.spaceBtwItems / 1.5,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 5,
              child: isLoading
                  ? const SShimmerEffect(width: 80, height: 15)
                  : Text(
                      value,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            Expanded(
              child: Icon(
                icon,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}