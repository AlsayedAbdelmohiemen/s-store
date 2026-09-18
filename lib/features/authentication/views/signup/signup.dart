import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:s_store/common/widgets/widgets.logi_signup/form_divider.dart';
import 'package:s_store/common/widgets/widgets.logi_signup/social_buttons.dart';
import 'package:s_store/features/authentication/views/signup/widget/ssignup_form.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/texts.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SSizes.defaultSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ///Title
              Text(
                STexts.signupTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: SSizes.spaceBtwSections,
              ),

              ///Form
              const SSignupForm(),
              const SizedBox(
                height: SSizes.spaceBtwSections,
              ),

              ///Divider
              SFormDivider(
                dividerText: STexts.orSignUpWith.capitalize!,
              ),

              const SizedBox(
                height: SSizes.spaceBtwSections,
              ),

              ///Social Icons
              const SSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
