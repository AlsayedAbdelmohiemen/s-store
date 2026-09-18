import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

class SRoundedImage extends StatelessWidget {
  const SRoundedImage({
    super.key,
    this.width,
    this.height,
    required this.imageUrl,
    this.applyImageRadius = true,
    this.border,
    this.backgroundColor,
    this.fit = BoxFit.contain,
    this.padding,
    this.isNetworkImage = false,
    this.onPressed,
    this.borderRadius = SSizes.md,
  });

  final double? width, height;
  final String imageUrl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color? backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
          borderRadius: applyImageRadius
              ? BorderRadius.circular(borderRadius)
              : BorderRadius.zero,
          child: imageUrl.isEmpty
              ? Container(
                  color: backgroundColor ??
                      (dark ? SColors.darkerGrey : SColors.light),
                  child: const Center(
                    child: Icon(Icons.image_not_supported,
                        size: 24, color: SColors.grey),
                  ),
                )
              : Image(
                  fit: fit,
                  image: isNetworkImage
                      ? NetworkImage(imageUrl)
                      : AssetImage(imageUrl) as ImageProvider,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: backgroundColor ??
                        (dark ? SColors.darkerGrey : SColors.light),
                    child: const Center(
                      child: Icon(Icons.broken_image,
                          size: 24, color: SColors.grey),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}