import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:s_store/common/widgets/images/s_circular_image.dart';
import 'package:s_store/common/widgets/shimmers/shimmer.dart';
import 'package:s_store/features/personalization/controllers/user_controller.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/constants/image_strings.dart';

class SUserProfileTile extends StatelessWidget {
  const SUserProfileTile({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return ListTile(
      leading: Obx(() {
        if (controller.profileLoading.value) {
          return const SShimmerEffect(width: 50, height: 50, radius: 50);
        }
        final networkImage = controller.user.value.profilePicture;
        final image = networkImage.isNotEmpty ? networkImage : SImages.user;
        return SCircularImage(
          image: image,
          width: 50,
          height: 50,
          padding: 0,
          isNetworkImage: networkImage.isNotEmpty,
        );
      }),
      title: Obx(
        () {
          if (controller.profileLoading.value) {
            return const SShimmerEffect(width: 80, height: 15);
          }
          return Text(
            controller.user.value.fullName.isNotEmpty
                ? controller.user.value.fullName
                : 'User',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .apply(color: SColors.white),
          );
        },
      ),
      subtitle: Obx(
        () {
          if (controller.profileLoading.value) {
            return const SShimmerEffect(width: 120, height: 12);
          }
          return Text(
            controller.user.value.email.isNotEmpty
                ? controller.user.value.email
                : '',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .apply(color: SColors.white),
          );
        },
      ),
      trailing: IconButton(
        onPressed: onPressed,
        icon: const Icon(
          Iconsax.edit,
          color: SColors.white,
        ),
      ),
    );
  }
}
