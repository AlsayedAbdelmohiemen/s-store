import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:s_store/features/authentication/views/onboarding_screen/widget/circular_button.dart';
import 'package:s_store/features/authentication/views/onboarding_screen/widget/onboarding_dot_navigation.dart';
import 'package:s_store/features/authentication/views/onboarding_screen/widget/onboarding_page.dart';
import 'package:s_store/features/authentication/views/onboarding_screen/widget/onboarding_skip.dart';
import 'package:s_store/utils/constants/image_strings.dart';
import '../../../../utils/constants/texts.dart';
import '../../controllers_onboarding/onboarding_controller.dart';


class OnBoardingScreen extends StatelessWidget {
  final controller = Get.put(OnBoardingController());

   OnBoardingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                image: SImages.onBoardingImage1,
                title: STexts.onBoardingTitle1,
                subTitle: STexts.onBoardingSubTitle1,
              ),
              OnBoardingPage(
                image: SImages.onBoardingImage2,
                title: STexts.onBoardingTitle2,
                subTitle: STexts.onBoardingSubTitle2,
              ),
              OnBoardingPage(
                image: SImages.onBoardingImage3,
                title: STexts.onBoardingTitle3,
                subTitle: STexts.onBoardingSubTitle3,
              )
            ],
          ),
          // Skip Button
          const OnBoardingSkip(),
          //dot navigation  SmoothPageIndicator
          const OnBoardingDotNavigation(),
          // circular button
          const CircularButton()
        ],
      ),
    );
  }
}


