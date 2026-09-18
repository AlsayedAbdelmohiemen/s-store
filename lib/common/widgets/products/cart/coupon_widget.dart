import 'package:flutter/material.dart';
import 'package:s_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/utils/helpers/helper_functions.dart';

class SCouponCode extends StatelessWidget {
  const SCouponCode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);

    return SRoundedContainer(
      showBorder: true,
      backgroundColor: dark ? SColors.dark : SColors.white,
      padding: const EdgeInsets.only(
        top: SSizes.sm,
        bottom: SSizes.sm,
        right: SSizes.sm,
        left: SSizes.md,
      ),
      child: Row(
        children: [
          /// -- Text Field
          Flexible(
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Have a promo code? Enter here',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            ),
          ),

          /// -- Button
          SizedBox(
            width: 80,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: dark
                    ? SColors.white.withValues(alpha: 0.5)
                    : SColors.dark.withValues(alpha: 0.5),
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
              ),
              child: const Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }
}
