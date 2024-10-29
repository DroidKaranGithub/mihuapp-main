import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mihu/home-flow/greeting/contollers/top_slider_controller.dart';
import 'package:sizer/sizer.dart';

class TopSlider extends StatelessWidget {
  // final TopSliderController controller = Get.find();
  final TopSliderController controller = Get.put(TopSliderController());

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => controller.changeIndex(0),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5.w),
            decoration: BoxDecoration(
              color: controller.selectedIndex.value == 0
                  ? Colors.grey.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '18 July 2024',
              style: TextStyle(
                fontSize: 13.sp,
                color: controller.selectedIndex.value == 0
                    ? Colors.black
                    : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ),
        SizedBox(width: 3.w),
        GestureDetector(
          onTap: () => controller.changeIndex(1),
          child: Obx(() => Container(
            padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5.w),
            decoration: BoxDecoration(
              color: controller.selectedIndex.value == 1
                  ? Colors.grey.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Future List',
              style: TextStyle(
                fontSize: 13.sp,
                color: controller.selectedIndex.value == 1
                    ? Colors.black
                    : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          )),
        ),
      ],
    );
  }
}
