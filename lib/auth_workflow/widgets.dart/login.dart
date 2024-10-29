// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mihu/constrants/colors/colors.dart';
// import 'package:mihu/home-flow/home/screen/homescreen.dart';
// import 'package:mihu/home-flow/languagesection/screens/language.dart';
// import 'package:mihu/shared_widgets/buttons/bottombutton.dart';
// import 'package:mihu/shared_widgets/passwordinputfield/passwordfield.dart';
// import 'package:sizer/sizer.dart';
// import 'package:url_launcher/url_launcher.dart'; // Add this import for launching URLs
//
// class LoginForm extends StatelessWidget {
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final FocusNode mobileFocusNode = FocusNode();
//   final FocusNode passwordFocusNode = FocusNode();
//   final FocusNode mpasswordFocusNode = FocusNode();
//
//   LoginForm({super.key});
//
//   Future<void> _launchPrivacyPolicy() async {
//     const url = 'https://www.google.com'; // Test with a simple URL
//     final Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white, // Replace with primarybackgroundColor
//       body: Padding(
//         padding: EdgeInsets.all(4.w),
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           child: Text(
//                             "Mobile Number",
//                             style:
//                                 TextStyle(color: Colors.black, fontSize: 12.sp),
//                           ),
//                         ),
//                         SizedBox(height: 1.h),
//                         Container(
//                           width: 80.w, // Reduced width for the container
//                           decoration: BoxDecoration(
//                             color: Colors.white, // Replace with primaryboxColor
//                             borderRadius: BorderRadius.circular(8),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.5),
//                                 spreadRadius: 2,
//                                 blurRadius: 5,
//                                 offset: const Offset(0, 3),
//                               ),
//                             ],
//                           ),
//                           child: TextFormField(
//                             controller: mobileController,
//                             focusNode: mobileFocusNode,
//                             textInputAction: TextInputAction.next,
//                             onFieldSubmitted: (value) {
//                               mobileFocusNode.unfocus();
//                               FocusScope.of(context)
//                                   .requestFocus(passwordFocusNode);
//                             },
//                             style: const TextStyle(color: Colors.black),
//                             decoration: InputDecoration(
//                               hintText: "Enter Mobile Number",
//                               hintStyle: const TextStyle(color: Colors.grey),
//                               border: InputBorder.none,
//                               contentPadding: EdgeInsets.symmetric(
//                                   horizontal: 3.w, vertical: 2.h),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 3.h),
//                     Container(
//                       width: 80.w, // Reduced width for the container
//                       child: PasswordField(
//                         headText: "Enter Password",
//                         controller: passwordController,
//                         focusNode: passwordFocusNode,
//                         nextFocusNode: mpasswordFocusNode,
//                         hintText: "Enter your password",
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             BottomButton(
//                 color: primarybuttonColor, // Replace with primarybuttonColor
//                 text: "Login",
//                 onTap: () {
//                   Get.to(HomePage());
//                 })
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mihu/auth_workflow/controllers/login_controller.dart';
import 'package:mihu/constrants/colors/colors.dart';

import 'package:mihu/shared_widgets/buttons/bottombutton.dart';

import 'package:mihu/shared_widgets/passwordinputfield/passwordfield.dart';
import 'package:sizer/sizer.dart';

import 'package:url_launcher/url_launcher.dart'; // Add this import for launching URLs




class LoginForm extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  LoginForm({super.key});

  Future<void> _launchPrivacyPolicy() async {
    const url = 'https://www.google.com'; // Test with a simple URL
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }




  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController());
    return Scaffold(
      backgroundColor: Colors.white, // Replace with primarybackgroundColor
      body: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "Email",
                            style: TextStyle(color: Colors.black, fontSize: 14.sp),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Container(
                          width: 80.w, // Adjusted width for the container
                          decoration: BoxDecoration(
                            color: Colors.white, // Replace with primaryboxColor
                            borderRadius: BorderRadius.circular(8),
                           border: Border.all(color:  Colors.grey)
                          ),
                          child: TextFormField(
                            controller: emailController,
                            focusNode: emailFocusNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) {
                              emailFocusNode.unfocus();
                              FocusScope.of(context).requestFocus(passwordFocusNode);
                            },
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: "Enter Email",
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 2.h),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Container(
                      width: 80.w, // Adjusted width for the container
                      child: PasswordField(
                        headText: "Enter Password",
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                        hintText: "Enter your password",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        nextFocusNode: passwordFocusNode,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BottomButton(
              color: primarybuttonColor, // Replace with primarybuttonColor
              text: "Login",
              onTap: () {
                loginController.
                loginUser(emailController.text, passwordController.text);
              },
            )
          ],
        ),
      ),
    );
  }
}

