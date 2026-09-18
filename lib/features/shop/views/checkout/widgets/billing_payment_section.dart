import 'package:flutter/material.dart';
import 'package:s_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:s_store/common/widgets/texts/section_heading.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/constants/image_strings.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/utils/helpers/helper_functions.dart';

class SBillingPaymentSection extends StatelessWidget {
  const SBillingPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);

    return Column(
      children: [
        SSectionHeading(
          title: 'Payment Method',
          buttonTitle: 'Change',
          onPressed: () {},
        ),
        const SizedBox(height: SSizes.spaceBtwItems / 2),
        Row(
          children: [
            SRoundedContainer(
              width: 60,
              height: 35,
              backgroundColor: dark ? SColors.light : SColors.white,
              padding: const EdgeInsets.all(SSizes.sm),
              child: const Image(
                image: AssetImage(SImages.paypal),
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: SSizes.spaceBtwItems / 2),
            Text(
              'Paypal',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }
}
