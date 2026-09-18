import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/widgets/loaders/animation_loader.dart';
import '../constants/colors.dart';
import '../helpers/helper_functions.dart';

/// A utility class for managing a full-screen loading dialog.
class TFullScreenLoader {
  /// Open a full-screen loading dialog with a given text and animation.
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Container(
          color: SHelperFunctions.isDarkMode(Get.context!) ? SColors.dark : SColors.white,
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              child: TAnimationLoaderWidget(text: text, animation: animation),
            ),
          ),
        ),
      ),
    );
  }

  /// Stop the currently open loading dialog safely.
  static void stopLoading() {
    if (Get.overlayContext != null && Navigator.of(Get.overlayContext!, rootNavigator: true).canPop()) {
      Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
    } else if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
