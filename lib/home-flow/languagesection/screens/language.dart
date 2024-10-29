// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mihu/constrants/colors/colors.dart';
// import 'package:mihu/home-flow/buisness_personal/screen/pagebuisness.dart';
// import 'package:mihu/home-flow/languagesection/controllers/languagecontroller.dart';
// import 'package:mihu/home-flow/languagesection/elements/languagecard.dart';
// import 'package:mihu/shared_widgets/buttons/bottombutton.dart';
// import 'package:mihu/welcome_workflow/controllers/logo_controller.dart';
// import 'package:sizer/sizer.dart';
//
// class LanguageSelectionPage extends StatelessWidget {
//   LanguageSelectionPage({super.key});
//   final LanguageController controller = Get.put(LanguageController());
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: primarybackgroundColor,
//       body: Container(
//         padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(height: 5.h),
//
//
//             Image.asset('assets/images/mihulogo.png',
//                 height: 15.h), // Replace with your logo asset
//             SizedBox(height: 3.h),
//             Text(
//               "Choose your preferred language for cards",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 14.sp, color: Colors.black),
//             ),
//             Text(
//               "कार्ड के लिए अपनी पसंदीदा भाषा चुनें",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 14.sp, color: Colors.black),
//             ),
//             SizedBox(height: 3.h),
//             Obx(() => LanguageCard(
//                   language: 'English',
//                   isSelected: controller.selectedLanguage.value == 'English',
//                   onTap: () {
//                     controller.selectLanguage('English');
//                     Get.to(UseSelectionPage());
//                   },
//                 )),
//             SizedBox(height: 2.h),
//             Obx(() => LanguageCard(
//                   language: 'Hindi',
//                   isSelected: controller.selectedLanguage.value == 'Hindi',
//                   onTap: () {
//                     controller.selectLanguage('Hindi');
//                     Get.to(UseSelectionPage());
//                   },
//                 )),
//
//             SizedBox(height: 5.h),
//             Text(
//               "Note:",
//               style: TextStyle(fontSize: 12.sp, color: Colors.black),
//             ),
//             Text(
//               "You can change it later.",
//               style: TextStyle(fontSize: 12.sp, color: Colors.black),
//             ),
//             Text(
//               "आप बाद में इसे बदल सकते हैं।",
//               style: TextStyle(fontSize: 12.sp, color: Colors.black),
//             ),
//             const Spacer(),
//             BottomButton(
//                 color: primarybuttonColor,
//                 text: "Back",
//                 onTap: () {
//                   Get.back();
//                 })
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/network/apiclient.dart/apicilent.dart';
import 'package:mihu/home-flow/buisness_personal/screen/pagebuisness.dart';
import 'package:mihu/home-flow/languagesection/controllers/languagecontroller.dart';
import 'package:mihu/home-flow/languagesection/elements/languagecard.dart';
import 'package:mihu/shared_widgets/buttons/bottombutton.dart';
import 'package:sizer/sizer.dart';

class LanguageSelectionPage extends StatelessWidget {
  LanguageSelectionPage({super.key});
  final LanguageController controller = Get.put(LanguageController(apiClient: ApiClient()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarybackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
        child: Obx(() {

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 5.h),
                Image.asset('assets/images/mihulogo.png', height: 15.h), // Replace with your logo asset
                SizedBox(height: 3.h),
                Text(
                  "Choose your preferred language for cards",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black),
                ),

                Text(
                  "कार्ड के लिए अपनी पसंदीदा भाषा चुनें",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black),
                ),
                SizedBox(height: 1.h),
                Expanded(
                  child: Wrap(
                    spacing: 11.w, // Horizontal space between cards
                    runSpacing: 2.1.h, // Vertical space between rows
                    children: List.generate(controller.languages.length, (index) {
                      var language = controller.languages[index];
                      return Container(
                        width: 38.w, // Adjust the width as needed
                        child: LanguageCard(
                          image: language['image'],
                          language: language['language_name'],
                          isSelected: controller.selectedLanguage.value == language['language_name'],
                          onTap: () {
                            controller.selectLanguage(language['language_name']);
                            Get.to(() => UseSelectionPage());
                          },
                        ),
                      );
                    }),
                  ),
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 3.h),
                    Text(
                      "Note:",
                      style: TextStyle(fontSize: 12.sp, color: Colors.black),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "You can change it later.",
                      style: TextStyle(fontSize: 12.sp, color: Colors.black),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "आप बाद में इसे बदल सकते हैं।",
                      style: TextStyle(fontSize: 12.sp, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                BottomButton(
                  color: primarybuttonColor,
                  text: "Back",
                  onTap: () {
                    Get.back();
                  },
                ),
            /*    BottomButton(
                  color: primarybuttonColor,
                  text: "Next",
                  onTap: () {
                    Get.to(() => UseSelectionPage());
                  },
                ),*/
              ],
            );

        }
        ),
      ),
    );
  }
}

