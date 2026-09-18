import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:s_store/features/authentication/controllers/signup/signup_controller.dart';
import 'package:s_store/features/authentication/views/signup/widget/sterms_condition_checkbox.dart';
import 'package:s_store/utils/validators/validation.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/texts.dart';

class SSignupForm extends StatelessWidget {
  const SSignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());

    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          /// First & Last Name
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value) => TValidator.validateEmptyText('First name', value),
                  expands: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.user),
                    labelText: STexts.firstName,
                  ),
                ),
              ),
              const SizedBox(width: SSizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (value) => TValidator.validateEmptyText('Last name', value),
                  expands: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.user),
                    labelText: STexts.lastName,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SSizes.spaceBtwInputFields),

          /// UserName
          TextFormField(
            controller: controller.username,
            validator: (value) => TValidator.validateEmptyText('Username', value),
            expands: false,
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.user_edit),
              labelText: STexts.username,
            ),
          ),
          const SizedBox(height: SSizes.spaceBtwInputFields),

          /// Email
          TextFormField(
            controller: controller.email,
            validator: (value) => TValidator.validateEmail(value),
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.direct),
              labelText: STexts.email,
            ),
          ),
          const SizedBox(height: SSizes.spaceBtwInputFields),

          /// Phone Number
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value) => TValidator.validatePhoneNumber(value),
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.call),
              labelText: STexts.phoneNo,
            ),
          ),
          const SizedBox(height: SSizes.spaceBtwInputFields),

          /// Date of Birth & Gender in a Row
          Row(
            children: [
              /// Date of Birth
              Expanded(
                child: TextFormField(
                  controller: controller.dateOfBirth,
                  readOnly: true,
                  onTap: () => controller.selectDateOfBirth(context),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.calendar_1),
                    labelText: 'Date of Birth',
                    hintText: 'DD/MM/YYYY',
                  ),
                ),
              ),
              const SizedBox(width: SSizes.spaceBtwInputFields),

              /// Gender Dropdown
              Expanded(
                child: Obx(
                  () => DropdownButtonFormField<String>(
                    initialValue: controller.gender.value,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.user),
                      labelText: 'Gender',
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Male', child: Text('Male')),
                      DropdownMenuItem(value: 'Female', child: Text('Female')),
                    ],
                    onChanged: (val) {
                      if (val != null) controller.gender.value = val;
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SSizes.spaceBtwInputFields),

          /// Password
          Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (value) => TValidator.validatePassword(value),
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                  icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                ),
                labelText: STexts.password,
              ),
            ),
          ),
          const SizedBox(height: SSizes.spaceBtwSections),

          /// Terms & conditions CheckBox
          const STermsAndConditionsCheckbox(),
          const SizedBox(height: SSizes.spaceBtwSections),

          /// Signup Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.signup(),
              child: const Text(STexts.createAccount),
            ),
          ),
        ],
      ),
    );
  }
}
