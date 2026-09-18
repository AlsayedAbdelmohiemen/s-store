import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

class SVerticalImageText extends StatefulWidget {
  const SVerticalImageText({
    super.key,
    required this.image,
    required this.title,
    this.textColor = SColors.white,
    this.backgroundColor,
    this.isNetworkImage = false,
    this.isSelected = false,
    this.onTap,
  });

  final String image, title;
  final Color textColor;
  final Color? backgroundColor;
  final bool isNetworkImage;
  final bool isSelected;
  final void Function()? onTap;

  @override
  State<SVerticalImageText> createState() => _SVerticalImageTextState();
}

class _SVerticalImageTextState extends State<SVerticalImageText> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);
    final isNetwork = widget.isNetworkImage || widget.image.startsWith('http');
    final isAssetIcon = !isNetwork && widget.image.isNotEmpty && widget.image.contains('assets/icons/');
    final active = _isPressed || widget.isSelected;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: Padding(
          padding: const EdgeInsets.only(right: SSizes.spaceBtwItems),
          child: Column(
            children: [
              // Outer interactive glowing ring
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 58,
                height: 58,
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: active ? SColors.primary : Colors.transparent,
                    width: active ? 2.2 : 0,
                  ),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: SColors.primary.withValues(alpha: 0.45),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: dark ? 0.25 : 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Container(
                  padding: const EdgeInsets.all(SSizes.sm),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor ??
                        (active
                            ? (dark ? SColors.primary.withValues(alpha: 0.25) : SColors.accent)
                            : (dark ? SColors.darkContainer : SColors.white)),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isNetwork
                        ? Image.network(
                            widget.image,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.category_outlined,
                              color: active
                                  ? SColors.primary
                                  : (dark ? SColors.light : SColors.dark),
                              size: 24,
                            ),
                          )
                        : (widget.image.isNotEmpty
                            ? Image(
                                image: AssetImage(widget.image),
                                fit: BoxFit.contain,
                                color: isAssetIcon
                                    ? (active
                                        ? SColors.primary
                                        : (dark ? SColors.light : SColors.dark))
                                    : null,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.category_outlined,
                                  color: active
                                      ? SColors.primary
                                      : (dark ? SColors.light : SColors.dark),
                                  size: 24,
                                ),
                              )
                            : Icon(
                                Icons.category_outlined,
                                color: active
                                    ? SColors.primary
                                    : (dark ? SColors.light : SColors.dark),
                                size: 24,
                              )),
                  ),
                ),
              ),

              /// Text
              const SizedBox(height: SSizes.spaceBtwItems / 2),
              SizedBox(
                width: 62,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 150),
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: active ? SColors.secondary : widget.textColor,
                        fontWeight: active ? FontWeight.bold : FontWeight.w500,
                      ),
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}