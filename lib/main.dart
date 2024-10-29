import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mihu/auth_workflow/controllers/login_controller.dart';
import 'package:mihu/auth_workflow/widgets.dart/login.dart';
import 'package:mihu/home-flow/home/screen/homescreen.dart';
import 'package:mihu/home-flow/profile/controller/profile_controller.dart';
import 'package:mihu/welcome_workflow/screen/splash.dart';
import 'package:mihu/welcome_workflow/screen/welcome.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

import 'network/apiclient.dart/apicilent.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    Get.put(LoginController());
    print("ApiClient().token ${ApiClient().token}");

    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          initialRoute: LoginController().storage.read('isLoggedIn') == true ? '/home' : '/',
          getPages: [
            GetPage(name: '/', page: () => SplashScreen()),
            GetPage(name: '/welcome', page: () => SocialLoginScreen()),
            GetPage(name: '/home', page: () => HomePage()),
            GetPage(name: '/login', page: () => LoginForm())
          ],
          // home: LanguageSelectionPage(),
        );
      },
    );
  }
}
