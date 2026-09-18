import 'package:flutter/material.dart';
import 'package:s_store/common/widgets/appbar/appbar.dart';
import 'package:s_store/common/widgets/products/ratings/rating_indicator.dart';
import 'package:s_store/features/shop/views/product_reviews/widgets/overall_product_rating.dart';
import 'package:s_store/features/shop/views/product_reviews/widgets/user_review_card.dart';
import 'package:s_store/utils/constants/sizes.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// -- Appbar
      appBar: const SAppBar(
        title: Text('Reviews & Ratings'),
        showBackArrow: true,
      ),

      /// -- Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ratings and reviews are verified and are from people who use the same type of device that you use.',
              ),
              const SizedBox(height: SSizes.spaceBtwItems),

              /// -- Overall Product Ratings
              const SOverallProductRating(),
              const SRatingBarIndicator(rating: 3.5),
              Text('12,611', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: SSizes.spaceBtwSections),

              /// -- User Reviews List
              const UserReviewCard(),
              const UserReviewCard(),
              const UserReviewCard(),
              const UserReviewCard(),
            ],
          ),
        ),
      ),
    );
  }
}
