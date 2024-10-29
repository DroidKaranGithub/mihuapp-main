import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mihu/home-flow/profiledeatails/personal/controller/profiledetailscontroller.dart';
import 'package:sizer/sizer.dart';

class DetailsToggle extends StatelessWidget {
  const DetailsToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '',
          style: TextStyle(fontSize: 14.sp),
        ),
        Row(
          children: [
            Text(
              'Add more details',
              style: TextStyle(fontSize: 12.sp),
            ),
            SizedBox(width: 2.w),
            Obx(
              () => Switch(
                value: Get.find<ProfileDetailsController>()
                    .isWhatsappEnabled
                    .value,
                onChanged: (value) {
                  Get.find<ProfileDetailsController>().toggleWhatsapp(value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
