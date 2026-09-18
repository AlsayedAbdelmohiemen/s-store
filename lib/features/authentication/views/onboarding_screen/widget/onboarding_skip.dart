import 'package:flutter/material.dart';
import 'package:s_store/features/authentication/controllers_onboarding/onboarding_controller.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/utils/device/device_utility.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: SDeviceUtils.getAppBarHeight(),
        right: SSizes.defaultSpace,
        child: TextButton(
          onPressed: () => OnBoardingController.instance.skipPage(),
          child: const Text("Skip"),
        ));
  }
}
