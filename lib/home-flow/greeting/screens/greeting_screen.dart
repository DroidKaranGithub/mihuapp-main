import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/home-flow/greeting/screens/tabs/greetings_future.dart';
import 'package:mihu/home-flow/greeting/screens/tabs/greetings_today.dart';
import 'package:mihu/home-flow/greeting/widgets/current_greeting.dart';
import 'package:mihu/home-flow/greeting/widgets/future_greetings.dart';
import 'package:mihu/home-flow/greeting/widgets/top_slider.dart';
import 'package:mihu/home-flow/home/controller/home_slider_controller.dart';
import 'package:mihu/home-flow/home/elements/business_home.dart';
import 'package:mihu/home-flow/home/elements/home_top_slider.dart';
import 'package:mihu/home-flow/home/elements/myself_home.dart';
import 'package:sizer/sizer.dart';

class GreetingScreen extends StatelessWidget {
  final HomeSlider2Controller controller = Get.put(HomeSlider2Controller());

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
              Obx(() {
                return Container(
                  color: backgroundColorWhite,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => controller.changeGreetingIndex(0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5.w),
                                  decoration: BoxDecoration(
                                    color: controller.selectedGreetingIndex.value == 0
                                        ? Colors.grey.withOpacity(0.1)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Today Greetings',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: controller.selectedGreetingIndex.value == 0
                                          ? Colors.black
                                          : Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    height: 1.5,
                                    width: 35.w, // Increased width for the underline
                                    color: controller.selectedGreetingIndex.value == 0
                                        ? Colors.black
                                        : Colors.transparent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Container(
                            height: 1.75.h,
                            width: 0.75,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 3.w),
                          GestureDetector(
                            onTap: () => controller.changeGreetingIndex(1),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5.w),
                                  decoration: BoxDecoration(
                                    color: controller.selectedGreetingIndex.value == 1
                                        ? Colors.grey.withOpacity(0.1)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Text(
                                    'Future Greetings',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: controller.selectedGreetingIndex.value == 1
                                          ? Colors.black
                                          : Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    height: 1.5,
                                    width: 35.w, // Increased width for the underline
                                    color: controller.selectedGreetingIndex.value == 1
                                        ? Colors.black
                                        : Colors.transparent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              Expanded(
                child: Obx(() {
                  // Switch between the UIs based on the selected index
                  return controller.selectedGreetingIndex.value == 0 ?  GreetingTodayScreen():GreetingFutureScreen() ;
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
