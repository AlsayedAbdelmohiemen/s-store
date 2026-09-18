import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/texts.dart';
import '../../../../utils/validators/validation.dart';
import '../../controllers/forget_password/set_new_password_controller.dart';

class SetNewPasswordScreen extends StatelessWidget {
  const SetNewPasswordScreen({super.key, this.email = ''});

  final String email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SetNewPasswordController(email: email));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Reset Password'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SSizes.defaultSpace),
          child: Form(
            key: controller.setNewPasswordFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Text(
                  'Set New Password',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: SSizes.spaceBtwItems),

                /// Subtitle
                Text(
                  email.isNotEmpty
                      ? 'Enter the 6-digit code sent to $email and your new password.'
                      : 'Your new password must be different from previously used passwords.',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: SSizes.spaceBtwSections * 1.5),

                /// 6-Digit OTP Code (shown when entering code manually)
                if (email.isNotEmpty) ...[
                  TextFormField(
                    controller: controller.otp,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        TValidator.validateEmptyText('Verification Code', value),
                    decoration: const InputDecoration(
                      labelText: '6-Digit Verification Code',
                      hintText: 'Enter 6-digit code',
                      prefixIcon: Icon(Iconsax.security_safe),
                    ),
                  ),
                  const SizedBox(height: SSizes.spaceBtwInputFields),
                ],

                /// New Password
                Obx(
                  () => TextFormField(
                    controller: controller.newPassword,
                    validator: TValidator.validatePassword,
                    obscureText: controller.hidePassword.value,
                    decoration: InputDecoration(
                      labelText: STexts.newPassword,
                      prefixIcon: const Icon(Iconsax.password_check),
                      suffixIcon: IconButton(
                        onPressed: () => controller.hidePassword.toggle(),
                        icon: Icon(
                          controller.hidePassword.value
                              ? Iconsax.eye_slash
                              : Iconsax.eye,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: SSizes.spaceBtwInputFields),

                /// Confirm Password
                Obx(
                  () => TextFormField(
                    controller: controller.confirmPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      return null;
                    },
                    obscureText: controller.hideConfirmPassword.value,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: const Icon(Iconsax.password_check),
                      suffixIcon: IconButton(
                        onPressed: () =>
                            controller.hideConfirmPassword.toggle(),
                        icon: Icon(
                          controller.hideConfirmPassword.value
                              ? Iconsax.eye_slash
                              : Iconsax.eye,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: SSizes.spaceBtwSections),

                /// Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.resetPassword(),
                    child: const Text(STexts.submit),
                  ),
                ),
                const SizedBox(height: SSizes.spaceBtwItems),

                /// Resend Code Button
                if (email.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => controller.resendOtp(),
                      child: const Text('Resend Code'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
