import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/home-flow/buisness_personal/controllers/selectioncontroller.dart';
import 'package:mihu/home-flow/buisness_personal/elements/typecard.dart';
import 'package:mihu/home-flow/profiledeatails/personal/controller/profiledetailscontroller.dart';
import 'package:mihu/shared_widgets/buttons/bottombutton.dart';
import 'package:sizer/sizer.dart';

import '../../profiledeatails/buisnessprofile/screens/buisness.dart';
import '../../profiledeatails/personal/screen/myselfdetailts.dart';

class UseSelectionPage extends StatelessWidget {
  UseSelectionPage({super.key});
  final SelectionController controller = Get.put(SelectionController());
  final ProfileDetailsController procontroller =
      Get.put(ProfileDetailsController());
  final storage = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarybackgroundColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 5.h),
            Image.asset('assets/images/mihulogo.png',
                height: 15.h), // Replace with your logo asset
            SizedBox(height: 3.h),
            Text(
              "Who do you want to create the card for?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.black),
            ),
            Text(
              "आप किसके लिए कार्ड बनाना चाहते हैं?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.black),
            ),

            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Obx(() => SelectionCard(
                        icon: Icons.business_center,
                        title: 'Business',
                        subtitle: 'मेरे व्यवसाय के लिए',
                        isSelected: controller.selectedCard.value == 'Business',
                        onTap: () {
                          storage.write('userType', "Business");
                          controller.userType="Business";
                          print("usertype------");
                          print(storage.read('userType'));
                          print(  controller.userType);

                          Get.to(MyBuissnessDetailsPage());
                          controller.selectCard('Business');
                        },
                      )),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Obx(() => SelectionCard(
                        icon: Icons.person,
                        title: 'Myself',
                        subtitle: 'मेरे लिए',
                        isSelected: controller.selectedCard.value == 'My Self',
                        onTap: () {
                          controller.selectCard('My Self');
                          controller.userType="My Self";
                          storage.write('userType', "My Self");
                          Get.to(MyDetailsPage());
                        },
                      )),
                ),
              ],
            ),
            SizedBox(height: 5.h),
            Text(
              "Note:",
              style: TextStyle(fontSize: 12.sp, color: Colors.black),
            ),
            Text(
              "You can change it later.",
              style: TextStyle(fontSize: 12.sp, color: Colors.black),
            ),
            Text(
              "आप बाद में इसे बदल सकते हैं।",
              style: TextStyle(fontSize: 12.sp, color: Colors.black),
            ),
            const Spacer(),
            BottomButton(
                color: primarybuttonColor,
                text: "Back",
                onTap: () {
                  Get.back();
                })
          ],
        ),
      ),
    );
  }
}
