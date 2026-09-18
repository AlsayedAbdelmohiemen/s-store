import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_store/common/widgets/texts/section_heading.dart';
import 'package:s_store/features/personalization/controllers/address_controller.dart';
import 'package:s_store/utils/constants/sizes.dart';

class SBillingAddressSection extends StatelessWidget {
  const SBillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final addressController = Get.put(AddressController());

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SSectionHeading(
            title: 'Shipping Address',
            buttonTitle: 'Change',
            onPressed: () => addressController.selectNewAddressPopup(context),
          ),
          addressController.selectedAddress.value.id.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      addressController.selectedAddress.value.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: SSizes.spaceBtwItems / 2),
                    Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.grey, size: 16),
                        const SizedBox(width: SSizes.spaceBtwItems),
                        Text(
                          addressController.selectedAddress.value.phoneNumber,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: SSizes.spaceBtwItems / 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_history,
                          color: Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: SSizes.spaceBtwItems),
                        Expanded(
                          child: Text(
                            addressController.selectedAddress.value.toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : TextButton(
                  onPressed: () =>
                      addressController.selectNewAddressPopup(context),
                  child: const Text('Select Address'),
                ),
        ],
      ),
    );
  }
}
