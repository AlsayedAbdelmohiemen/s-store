import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/texts.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/forget_password/forget_password_controller.dart';
import '../login/login.dart';
import 'set_new_password.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SSizes.defaultSpace),
          child: Column(
            children: [
              /// Image
              Image(
                image: const AssetImage(SImages.deliveredEmailIllustration),
                width: SHelperFunctions.screenWidth() * 0.6,
              ),
              const SizedBox(height: SSizes.spaceBtwSections),

              /// Email Text
              Text(
                email,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: SSizes.spaceBtwItems),

              /// Title & Subtitle
              Text(
                STexts.changeYourPasswordTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: SSizes.spaceBtwItems),
              Text(
                STexts.changeYourPasswordSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: SSizes.spaceBtwSections),

              /// Enter Code Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => SetNewPasswordScreen(email: email)),
                  child: const Text('Enter Code & Reset Password'),
                ),
              ),
              const SizedBox(height: SSizes.spaceBtwItems),

              /// Resend Email Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => ForgetPasswordController.instance.resendPasswordResetEmail(email),
                  child: const Text(STexts.resendEmail),
                ),
              ),
              const SizedBox(height: SSizes.spaceBtwItems),

              /// Back to Login Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Get.offAll(() => const LoginScreen()),
                  child: const Text('Back to Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
