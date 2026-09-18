import 'package:flutter/material.dart';

import 'package:s_store/utils/helpers/helper_functions.dart';
import '../../../utils/constants/colors.dart';

class SCircularIcon extends StatelessWidget {
  const SCircularIcon({
    super.key,
    this.width,
    this.height,
    this.size,
    required this.icon,
    this.color,
    this.backgroundColor,
    this.onPressed,
  });

  final double? width, height, size;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor != null
            ? backgroundColor!
            : SHelperFunctions.isDarkMode(context)
                ? SColors.black.withValues(alpha: 0.9)
                : SColors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon:  Icon(icon,color: color,size: size,),
      ),
    );
  }
}
