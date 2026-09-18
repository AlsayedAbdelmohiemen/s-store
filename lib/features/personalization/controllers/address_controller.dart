import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/texts/section_heading.dart';
import '../../../data/repositories/address/address_repository.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../models/address_model.dart';
import '../screens/address/add_new_address.dart';
import '../screens/address/widgets/single_address.dart';

class AddressController extends GetxController {
  static AddressController get instance => Get.find();

  final name = TextEditingController();
  final phoneNumber = TextEditingController();
  final street = TextEditingController();
  final postalCode = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final country = TextEditingController();
  final GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();

  final RxBool isLoading = false.obs;
  final RxBool refreshData = true.obs;
  final Rx<AddressModel> selectedAddress = AddressModel.empty().obs;
  final RxList<AddressModel> allAddresses = <AddressModel>[].obs;
  final addressRepository = Get.put(AddressRepository());

  @override
  void onInit() {
    super.onInit();
    getAllUserAddresses();
  }

  /// Fetch all user addresses from cloud repository
  Future<List<AddressModel>> getAllUserAddresses() async {
    try {
      isLoading.value = true;
      final addresses = await addressRepository.fetchUserAddresses();
      allAddresses.assignAll(addresses);

      if (addresses.isNotEmpty) {
        // Only set default if no address is currently selected
        if (selectedAddress.value.id.isEmpty) {
          final initial = addresses.firstWhere(
            (element) => element.selectedAddress,
            orElse: () => addresses.first,
          );
          initial.selectedAddress = true;
          selectedAddress.value = initial;
        } else {
          // Sync current selection with the fetched list
          for (var addr in addresses) {
            addr.selectedAddress = (addr.id == selectedAddress.value.id);
          }
          allAddresses.refresh();
        }
      }
      return addresses;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Address Not Found', message: e.toString());
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Select Address and update both local state and cloud repository seamlessly
  Future<void> selectAddress(AddressModel newSelectedAddress) async {
    try {
      // If already selected, do nothing
      if (selectedAddress.value.id == newSelectedAddress.id &&
          selectedAddress.value.id.isNotEmpty) {
        return;
      }

      final prevAddressId = selectedAddress.value.id;

      // 1. Deselect previously selected address locally
      if (prevAddressId.isNotEmpty) {
        selectedAddress.value.selectedAddress = false;
      }

      // 2. Assign newly selected address locally
      newSelectedAddress.selectedAddress = true;
      selectedAddress.value = newSelectedAddress;

      // 3. Update all addresses list state immediately for instant UI response
      for (var addr in allAddresses) {
        addr.selectedAddress = (addr.id == newSelectedAddress.id);
      }
      allAddresses.refresh();

      // 4. Update cloud database in the background without blocking the UI
      if (prevAddressId.isNotEmpty) {
        await addressRepository.updateSelectedField(prevAddressId, false);
      }
      await addressRepository.updateSelectedField(newSelectedAddress.id, true);
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error in Selection',
        message: e.toString(),
      );
    }
  }

  /// Add new address
  Future<void> addNewAddresses() async {
    try {
      // 1. Start Loading
      TFullScreenLoader.openLoadingDialog(
        'Storing Address...',
        SImages.docerAnimation,
      );

      // 2. Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // 3. Form Validation
      if (!addressFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // 4. Save Address Data
      final address = AddressModel(
        id: '',
        name: name.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        street: street.text.trim(),
        city: city.text.trim(),
        state: state.text.trim(),
        postalCode: postalCode.text.trim(),
        country: country.text.trim(),
        selectedAddress: true,
      );

      final id = await addressRepository.addAddress(address);
      address.id = id;

      // Deselect existing
      for (var addr in allAddresses) {
        addr.selectedAddress = false;
      }
      allAddresses.insert(0, address);
      selectedAddress.value = address;
      allAddresses.refresh();

      // Clear previous in background
      await addressRepository.updateSelectedField(id, true);

      // 5. Remove Loader
      TFullScreenLoader.stopLoading();

      // 6. Show Success Message
      TLoaders.successSnackBar(
        title: 'Congratulations',
        message: 'Your address has been saved successfully.',
      );

      // 7. Refresh Addresses Data
      refreshData.toggle();

      // 8. Reset Fields
      resetFormFields();

      // 9. Redirect
      Navigator.of(Get.context!).pop();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Address not found', message: e.toString());
    }
  }

  /// Show Addresses ModalBottomSheet at Checkout
  Future<dynamic> selectNewAddressPopup(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: const EdgeInsets.all(SSizes.lg),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SSectionHeading(
                title: 'Select Address',
                showActionsButton: false,
              ),
              const SizedBox(height: SSizes.spaceBtwItems),
              Obx(() {
                if (isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(SSizes.defaultSpace),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (allAddresses.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(SSizes.defaultSpace),
                      child: Text('No Address Found!'),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: allAddresses.length,
                  itemBuilder: (_, index) => SSingleAddress(
                    address: allAddresses[index],
                    onTap: () async {
                      await selectAddress(allAddresses[index]);
                      Get.back();
                    },
                  ),
                );
              }),
              const SizedBox(height: SSizes.defaultSpace * 2),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const AddNewAddressScreen()),
                  child: const Text('Add new address'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Function to reset form fields
  void resetFormFields() {
    name.clear();
    phoneNumber.clear();
    street.clear();
    postalCode.clear();
    city.clear();
    state.clear();
    country.clear();
    addressFormKey.currentState?.reset();
  }

  @override
  void onClose() {
    name.dispose();
    phoneNumber.dispose();
    street.dispose();
    postalCode.dispose();
    city.dispose();
    state.dispose();
    country.dispose();
    super.onClose();
  }
}
