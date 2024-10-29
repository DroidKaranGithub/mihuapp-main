import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/home-flow/home/controller/home_slider_controller.dart';
import 'package:mihu/home-flow/home/elements/business_home.dart';
import 'package:mihu/home-flow/home/elements/home_top_slider.dart';
import 'package:mihu/home-flow/home/elements/myself_home.dart';

class HomePageBody extends StatelessWidget {
  final HomeSliderController controller = Get.put(HomeSliderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarybackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            // Dismiss the keyboard when tapping outside the input field
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              HomeTopSlider(),
              Expanded(
                child: Obx(() => controller.selectedIndex.value == 0 ?  MyselfHome():BusinessHome(),)

              ),
            ],
          ),
        ),
      ),
    );
  }
}
