import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/address_controller.dart';
import '../../../models/address_model.dart';

class SSingleAddress extends StatelessWidget {
  const SSingleAddress({
    super.key,
    required this.address,
    required this.onTap,
  });

  final AddressModel address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance;
    final dark = SHelperFunctions.isDarkMode(context);

    return Obx(() {
      final selectedAddressId = controller.selectedAddress.value.id;
      final isSelected = selectedAddressId == address.id;

      return InkWell(
        onTap: onTap,
        child: SRoundedContainer(
          padding: const EdgeInsets.all(SSizes.md),
          width: double.infinity,
          showBorder: true,
          backgroundColor: isSelected
              ? SColors.primaryColor.withValues(alpha: 0.5)
              : Colors.transparent,
          borderColor: isSelected
              ? Colors.transparent
              : dark
                  ? SColors.darkerGrey
                  : SColors.grey,
          margin: const EdgeInsets.only(bottom: SSizes.spaceBtwItems),
          child: Stack(
            children: [
              Positioned(
                right: 5,
                top: 0,
                child: Icon(
                  isSelected ? Iconsax.tick_circle5 : null,
                  color: isSelected
                      ? dark
                          ? SColors.light
                          : SColors.dark.withValues(alpha: 0.6)
                      : null,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: SSizes.sm / 2),
                  Text(
                    address.formattedPhoneNo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: SSizes.sm / 2),
                  Text(
                    address.toString(),
                    softWrap: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}