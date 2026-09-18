import 'package:flutter/material.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });
  final String image, title, subTitle;
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        Padding(
          padding:  const EdgeInsets.all(SSizes.defaultSpace),
          child: Column(
            children: [
              Image(
                image: AssetImage(image),
                width: SHelperFunctions.screenWidth() * 0.8,
                height: SHelperFunctions.screenHeight() * 0.6,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: SSizes.spaceBtwItems,
              ),
              Text(
                subTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        )
      ],
    );
  }
}