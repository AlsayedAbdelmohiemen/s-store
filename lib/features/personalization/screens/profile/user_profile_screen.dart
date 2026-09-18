import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:s_store/common/widgets/appbar/appbar.dart';
import 'package:s_store/common/widgets/images/s_circular_image.dart';
import 'package:s_store/common/widgets/shimmers/shimmer.dart';
import 'package:s_store/utils/constants/image_strings.dart';
import 'package:s_store/utils/constants/sizes.dart';
import 'package:s_store/common/widgets/texts/section_heading.dart';
import 'package:s_store/utils/popups/loaders.dart';
import '../../controllers/user_controller.dart';
import 'change_name.dart';
import 'widgets/profile_menu.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    // Fetch user record if empty
    if (controller.user.value.id.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.fetchUserRecord();
      });
    }

    return Scaffold(
      appBar: const SAppBar(
        showBackArrow: true,
        title: Text('Profile'),
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchUserRecord(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(SSizes.defaultSpace),
            child: Column(
              children: [
                /// Profile Picture
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Obx(() {
                        final networkImage = controller.user.value.profilePicture;
                        final image = networkImage.isNotEmpty ? networkImage : SImages.user;
                        if (controller.imageUploading.value) {
                          return const SizedBox(
                            width: 80,
                            height: 80,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (controller.profileLoading.value) {
                          return const SShimmerEffect(width: 80, height: 80, radius: 80);
                        }
                        return SCircularImage(
                          image: image,
                          width: 80,
                          height: 80,
                          isNetworkImage: networkImage.isNotEmpty,
                        );
                      }),
                      TextButton(
                        onPressed: () => controller.uploadUserProfilePicture(),
                        child: const Text('Change Profile Picture'),
                      ),
                    ],
                  ),
                ),

              // -- Profile Details
              const SizedBox(height: SSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: SSizes.spaceBtwItems),
              const SSectionHeading(title: 'Profile Information', showActionsButton: false),
              const SizedBox(height: SSizes.spaceBtwItems),

              Obx(
                () => SProfileMenu(
                  title: 'Name',
                  value: controller.user.value.fullName.isNotEmpty
                      ? controller.user.value.fullName
                      : 'No Name',
                  isLoading: controller.profileLoading.value,
                  onPressed: () => Get.to(() => const ChangeNameScreen()),
                ),
              ),

              Obx(
                () => SProfileMenu(
                  title: 'Username',
                  value: controller.user.value.username.isNotEmpty
                      ? controller.user.value.username
                      : 'No Username',
                  isLoading: controller.profileLoading.value,
                  onPressed: () => controller.showEditFieldDialog(
                    title: 'Username',
                    fieldName: 'Username',
                    initialValue: controller.user.value.username,
                  ),
                ),
              ),

              const SizedBox(height: SSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: SSizes.spaceBtwItems),
              const SSectionHeading(title: 'Personal Information', showActionsButton: false),
              const SizedBox(height: SSizes.spaceBtwItems),

              Obx(
                () => SProfileMenu(
                  title: 'User ID',
                  value: controller.user.value.id.isNotEmpty
                      ? controller.user.value.id
                      : 'N/A',
                  isLoading: controller.profileLoading.value,
                  icon: Iconsax.copy,
                  onPressed: () {
                    if (controller.user.value.id.isNotEmpty) {
                      Clipboard.setData(ClipboardData(text: controller.user.value.id));
                      TLoaders.customToast(message: 'User ID copied to clipboard');
                    }
                  },
                ),
              ),

              Obx(
                () => SProfileMenu(
                  title: 'E-mail',
                  value: controller.user.value.email.isNotEmpty
                      ? controller.user.value.email
                      : 'No Email',
                  isLoading: controller.profileLoading.value,
                  onPressed: () {},
                ),
              ),

              Obx(
                () => SProfileMenu(
                  title: 'Phone Number',
                  value: controller.user.value.phoneNumber.isNotEmpty
                      ? controller.user.value.phoneNumber
                      : 'Add Phone',
                  isLoading: controller.profileLoading.value,
                  onPressed: () => controller.showEditFieldDialog(
                    title: 'Phone Number',
                    fieldName: 'PhoneNumber',
                    initialValue: controller.user.value.phoneNumber,
                  ),
                ),
              ),

              Obx(
                () => SProfileMenu(
                  title: 'Gender',
                  value: controller.user.value.gender.isNotEmpty
                      ? controller.user.value.gender
                      : 'Add Gender',
                  isLoading: controller.profileLoading.value,
                  onPressed: () => controller.showEditGenderDialog(context),
                ),
              ),

              Obx(
                () => SProfileMenu(
                  title: 'Date of Birth',
                  value: controller.user.value.dateOfBirth.isNotEmpty
                      ? controller.user.value.dateOfBirth
                      : 'Add Date of Birth',
                  isLoading: controller.profileLoading.value,
                  onPressed: () => controller.selectAndSaveDateOfBirth(context),
                ),
              ),

              const Divider(),
              const SizedBox(height: SSizes.spaceBtwItems),

              Center(
                child: TextButton(
                  onPressed: () => controller.deleteAccountWarningPopup(),
                  child: const Text('Close Account', style: TextStyle(color: Colors.red)),
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