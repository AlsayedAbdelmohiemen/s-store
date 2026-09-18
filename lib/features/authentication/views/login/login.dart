import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:s_store/common/styles/spacing_styles.dart';
import 'package:s_store/common/widgets/custom_shapes/containers/animated_ambient_background.dart';
import 'package:s_store/features/authentication/views/login/widget/slogin_form.dart';
import 'package:s_store/features/authentication/views/login/widget/slogin_header.dart';
import 'package:s_store/utils/constants/texts.dart';
import '../../../../common/widgets/widgets.logi_signup/form_divider.dart';
import '../../../../common/widgets/widgets.logi_signup/social_buttons.dart';
import '../../../../utils/constants/sizes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SAnimatedAmbientBackground(
      child: SingleChildScrollView(
        child: Padding(
          padding: SSpacingStyle.paddingWidthAppBarHeight,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Column(
              children: [
                /// SLoginHeader
                const SLoginHeader(),

                /// SLoginForm
                const SLoginForm(),

                /// divider
                SFormDivider(
                  dividerText: STexts.orSignInWith.capitalize!,
                ),
                const SizedBox(
                  height: SSizes.spaceBtwItems,
                ),

                /// Footer
                const SSocialButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
