import 'package:flutter/material.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/helpers/helper_functions.dart';
import '../../../utils/device/device_utility.dart';

class STabBar extends StatelessWidget implements PreferredSizeWidget {
  const STabBar({super.key, required this.tabs});

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);
    return Material(
      color: dark ? SColors.black : SColors.white,
      child: TabBar(
        isScrollable: true,
        indicatorColor: SColors.primaryColor,
        unselectedLabelColor: SColors.darkGrey,
        labelColor: dark ? SColors.white : SColors.primaryColor,
        tabs: tabs,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(SDeviceUtils.getAppBarHeight());
}
