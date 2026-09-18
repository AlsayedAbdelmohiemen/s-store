import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:s_store/features/authentication/controllers_onboarding/onboarding_controller.dart';
import 'package:s_store/utils/constants/sizes.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class CircularButton extends StatelessWidget {
  const CircularButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);
    return Positioned(
        right: SSizes.defaultSpace,
        bottom: SDeviceUtils.getBottomNavigationBarHeight(),
        child: ElevatedButton(
          onPressed: () => OnBoardingController.instance.nextPage(),
          style:ElevatedButton.styleFrom(shape:const CircleBorder() ,backgroundColor:dark? SColors.primaryColor: Colors.black) ,
          child: const Icon(Iconsax.arrow_right_3),
        ));
  }
}
