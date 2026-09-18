import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:s_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:s_store/common/widgets/products/ratings/rating_indicator.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/constants/image_strings.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/utils/helpers/helper_functions.dart';

class UserReviewCard extends StatelessWidget {
  const UserReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);

    return Column(
      children: [
        /// User Info Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage(SImages.userProfileImage3),
                ),
                const SizedBox(width: SSizes.spaceBtwItems),
                Text(
                  'John Doe',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        const SizedBox(height: SSizes.spaceBtwItems),

        /// Review Rating & Date
        Row(
          children: [
            const SRatingBarIndicator(rating: 4),
            const SizedBox(width: SSizes.spaceBtwItems),
            Text(
              '01 Nov, 2023',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: SSizes.spaceBtwItems),

        /// Review Text
        const ReadMoreText(
          'The user interface of the app is quite intuitive. I was able to navigate and make purchases seamlessly. Great job!',
          trimLines: 2,
          trimMode: TrimMode.Line,
          trimExpandedText: ' show less',
          trimCollapsedText: ' show more',
          moreStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: SColors.primaryColor,
          ),
          lessStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: SColors.primaryColor,
          ),
        ),
        const SizedBox(height: SSizes.spaceBtwItems),

        /// Company / Store Reply
        SRoundedContainer(
          backgroundColor: dark ? SColors.darkerGrey : SColors.grey,
          padding: const EdgeInsets.all(SSizes.md),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "S's Store",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '02 Nov, 2023',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: SSizes.spaceBtwItems),
              const ReadMoreText(
                'Thank you for your feedback! We are constantly working on improving our platform and user experience.',
                trimLines: 2,
                trimMode: TrimMode.Line,
                trimExpandedText: ' show less',
                trimCollapsedText: ' show more',
                moreStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: SColors.primaryColor,
                ),
                lessStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: SColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: SSizes.spaceBtwSections),
      ],
    );
  }
}
