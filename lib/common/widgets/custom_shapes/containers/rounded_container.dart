import 'package:flutter/cupertino.dart';
import 'package:s_store/utils/constants/sizes.dart';

import '../../../../utils/constants/colors.dart';

class SRoundedContainer extends StatelessWidget {
  const SRoundedContainer(
      {super.key,
      this.width,
      this.height,
      this.radius = SSizes.cardRadiusLg,
      this.showBorder = false,
      this.padding,
      this.margin,
      this.child,
      this.borderColor = SColors.borderPrimary,
      this.backgroundColor = SColors.white});
  final double? width;
  final double? height;
  final double radius;
  final bool showBorder;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget? child;
  final Color borderColor;
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: showBorder ? Border.all(color: borderColor) : null,
      ),
      child: child,
    );
  }
}
