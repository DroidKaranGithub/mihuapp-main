import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/home-flow/greeting/screens/greeting_screen.dart';
import 'package:mihu/home-flow/home/elements/home_body.dart';
import 'package:mihu/home-flow/profile/screens/profile_page.dart';
import 'package:mihu/shared_widgets/navigationbar/navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../auth_workflow/screens/login_signup.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        showAlertDialog(context);
      },
      child: Scaffold(
        backgroundColor: primarybackgroundColor,
        body: Obx(() {
          // Observe the current index from NavBarController
          final currentIndex = Get.find<NavBarController>().currentIndex.value;
          switch (currentIndex) {
            case 1:
              return GreetingScreen();
            case 2:
              return ProfilePage();
            default:
              return HomePageBody();
          }
        }),
        bottomNavigationBar: NavBar(),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    final storage = GetStorage();
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        Get.back();
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text(
        "Continue",
        style: TextStyle(color: Colors.blue),
      ),
      onPressed: () async {
        Get.to(LoginSignup());
        SharedPreferences prefrences = await SharedPreferences.getInstance();
        await prefrences.clear();
        await storage.erase();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Are you sure you want to logout"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
