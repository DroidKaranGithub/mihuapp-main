import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mihu/constrants/colors/colors.dart';

class NavBarController extends GetxController {
  var currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}

class NavBar extends StatelessWidget {
  final NavBarController navBarController = Get.put(NavBarController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: navBarController.currentIndex.value,
        onTap: navBarController.changeIndex,
        selectedItemColor: Colors.black,
        elevation: 1,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Opacity(
              opacity: navBarController.currentIndex.value == 0 ? 1.0 : 0.5,
              child: ImageIcon(AssetImage('assets/icons/home.png')),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Opacity(
              opacity: navBarController.currentIndex.value == 1 ? 1.0 : 0.5,
              child: ImageIcon(AssetImage('assets/icons/greeting.png')),
            ),
            label: 'Greeting',
          ),
          BottomNavigationBarItem(
            icon: Opacity(
              opacity: navBarController.currentIndex.value == 2 ? 1.0 : 0.5,
              child: ImageIcon(AssetImage('assets/icons/profileicon.png')),
            ),
            label: 'Profile',
          ),
        ],
      );
    });
  }
}
