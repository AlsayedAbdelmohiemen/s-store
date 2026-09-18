import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_store/bindings/general_bindings.dart';
import 'package:s_store/utils/constants/colors.dart';
import 'package:s_store/utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: SAppTheme.lightTheme,
      darkTheme: SAppTheme.darkTheme,
      initialBinding: GeneralBindings(),
      debugShowCheckedModeBanner: false,

      /// Native Splash Screen is displayed natively while AuthenticationRepository resolves initial route
      home: const Scaffold(
        backgroundColor: SColors.primary,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );
  }
}
