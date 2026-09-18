import 'package:flutter/material.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/utils/helpers/helper_functions.dart';

class SCircularImage extends StatelessWidget {
  const SCircularImage({
    super.key,
    this.fit = BoxFit.cover,
    required this.image,
     this.isNetworkImage = false,
    this.overlayColor,
    this.backgroundColor,
     this.width = 56,
     this.height = 56,
     this.padding = SSizes.sm,
  });

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;
  @override
  Widget build(BuildContext context) {
    final isNetwork = isNetworkImage || image.startsWith('http');

    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ??
            (SHelperFunctions.isDarkMode(context)
                ? SColors.black
                : SColors.white),
        borderRadius: BorderRadius.circular(100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Center(
          child: isNetwork
              ? Image.network(
                  image,
                  fit: fit,
                  color: overlayColor,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.store_mall_directory_outlined,
                    color: overlayColor,
                    size: width * 0.5,
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                )
              : Image(
                  fit: fit,
                  image: AssetImage(image),
                  color: overlayColor,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.store_mall_directory_outlined,
                    color: overlayColor,
                    size: width * 0.5,
                  ),
                ),
        ),
      ),
    );
  }
}
