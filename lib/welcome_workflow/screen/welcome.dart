import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mihu/auth_workflow/screens/login_signup.dart';
import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/shared_widgets/buttons/facebookbtn.dart';
import 'package:mihu/shared_widgets/buttons/googlebtn.dart';
import 'package:mihu/shared_widgets/carsoles/carsoules.dart';
import 'package:mihu/welcome_workflow/controllers/logo_controller.dart';
import 'package:sizer/sizer.dart';

class SocialLoginScreen extends StatelessWidget {
  final List<String> imgList = [
    'assets/images/crouseltwo.png',
    'assets/images/crouselone.jpg'
  ];
  // final logoController = Get.put(LogoController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primarybackgroundColor,
        body:  GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Dismiss the keyboard
          },
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/mihulogo.png', // Replace with your logo asset
                        width: 25.w, // Reduced size for the logo
                        height: 13.h,
                      ),

                      // Obx(()=>
                      //     logoController.logoUrl.value.data.isEmpty ? CircularProgressIndicator()
                      //         : Image.network(
                      //       logoController.logoUrl.value.data,
                      //       height: 25.w,
                      //       width: 13.h,
                      //     )
                      // ),
                      Text(
                        'Personalize, Create, & Share Posts',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Expanded(
                  flex: 2,
                  child: ReusableCarousel(imgList: imgList),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      FacebookButton(onPressed: () {
                        // Handle Facebook login
                      }),
                      SizedBox(height: 2.h),
                      GoogleButton(onPressed: () {
                        // Handle Google login
                      }),
                      SizedBox(height: 1.h),
                      Text(
                        'or',
                        style: TextStyle(
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      GestureDetector(
                        onTap: () {
                          Get.to(LoginSignup());
                        },
                        child: Text(
                          'Sign Up / Log In manually',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            'By signing up/logging in, I agree to the privacy policy.',
                            style: TextStyle(fontSize: 8.sp, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
