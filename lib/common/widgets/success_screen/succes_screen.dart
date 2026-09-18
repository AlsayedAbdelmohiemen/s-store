import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:s_store/common/styles/spacing_styles.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/texts.dart';
import '../../../utils/helpers/helper_functions.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    super.key,
    required this.image,
    this.animation,
    required this.title,
    required this.subTitle,
    required this.onPressed,
  });

  final String image, title, subTitle;
  final String? animation;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isJson = image.endsWith('.json');
    final lottieAnim = animation ?? (isJson ? image : null);

    return Scaffold(
      body: SingleChildScrollView(
        padding: SSpacingStyle.paddingWidthAppBarHeight * 2,
        child: Column(
          children: [
            /// Lottie Animation if provided or if image is a json asset
            if (lottieAnim != null && lottieAnim.isNotEmpty) ...[
              Lottie.asset(
                lottieAnim,
                width: SHelperFunctions.screenWidth() * 0.7,
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  width: 80,
                  height: 80,
                  child: Center(child: Icon(Icons.check_circle, size: 60, color: Colors.green)),
                ),
              ),
              const SizedBox(height: SSizes.spaceBtwItems),
            ] else if (image.isNotEmpty && !isJson) ...[
              /// Standard Image
              Image(
                image: AssetImage(image),
                width: SHelperFunctions.screenWidth() * 0.5,
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  width: 80,
                  height: 80,
                  child: Center(child: Icon(Icons.check_circle, size: 60, color: Colors.green)),
                ),
              ),
              const SizedBox(height: SSizes.spaceBtwItems),
            ],

            const SizedBox(height: SSizes.spaceBtwSections),

            /// Title & Subtitle
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SSizes.spaceBtwItems),
            Text(
              subTitle,
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SSizes.spaceBtwSections),

            /// Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                child: const Text(STexts.tContinue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
