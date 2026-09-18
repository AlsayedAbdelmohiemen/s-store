import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'data/repositories/authentication/authentication_repository.dart';
import 'utils/constants/app_env.dart';

Future<void> main() async {
  /// -- Widgets Binding
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  /// -- GetX Local Storage
  await GetStorage.init();

  /// -- Preserve Native Splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// -- Initialize Supabase
  await Supabase.initialize(
    url: SAppEnv.supabaseUrl,
    publishableKey: SAppEnv.supabasePublishableKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.implicit,
    ),
  );

  /// -- Initialize Authentication Repository
  Get.put(AuthenticationRepository());

  /// -- Main App
  runApp(const App());
}
