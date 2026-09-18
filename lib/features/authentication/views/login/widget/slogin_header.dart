import 'package:flutter/material.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/constants/sizes.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/texts.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class SLoginHeader extends StatelessWidget {
  const SLoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: SSizes.md),
          height: 100,
          width: 100,
          child: Image(
            image: AssetImage(dark ? SImages.lightAppLogo : SImages.darkAppLogo),
            fit: BoxFit.contain,
          ),
        ),
        Text(
          STexts.loginTitle,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: SSizes.sm),
        Text(
          STexts.loginSubTitle,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: SColors.textSecondary,
                height: 1.4,
              ),
        ),
      ],
    );
  }
}
