import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/home-flow/home/controller/home_slider_controller.dart';
import 'package:sizer/sizer.dart';

class HomeTopSlider extends StatefulWidget {
  @override
  State<HomeTopSlider> createState() => _HomeTopSliderState();
}

class _HomeTopSliderState extends State<HomeTopSlider> {
  final HomeSliderController controller = Get.find();
@override
void initState() {
  controller.changeIndex(0);
  controller.getProfileDialog(context);
  // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        color: backgroundColorWhite,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => controller.changeIndex(0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5.w),
                        decoration: BoxDecoration(
                          color: controller.selectedIndex.value == 0
                              ? Colors.grey.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Myself',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: controller.selectedIndex.value == 0
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
                          color: controller.selectedIndex.value == 0
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
                  onTap: () => controller.changeIndex(1),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5.w),
                        decoration: BoxDecoration(
                          color: controller.selectedIndex.value == 1
                              ? Colors.grey.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          'Business',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: controller.selectedIndex.value == 1
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
                          color: controller.selectedIndex.value == 1
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
    });
  }
}