import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mihu/auth_workflow/controllers/authtoggle.dart';
import 'package:mihu/auth_workflow/controllers/signup_controller.dart';
import 'package:mihu/auth_workflow/widgets.dart/login.dart';
import 'package:mihu/auth_workflow/widgets.dart/signup.dart';
import 'package:sizer/sizer.dart';

class LoginSignup extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final PageController _pageController = PageController();

  LoginSignup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Replace with your primary background color
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 6.h,
            ),
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      authController.isLoginForm.value = true;
                      _pageController.animateToPage(0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 6.w),
                          decoration: BoxDecoration(
                            color: authController.isLoginForm.value
                                ? Colors.grey.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: authController.isLoginForm.value
                                  ? Colors.black
                                  : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: 2,
                            width: 40.w, // Fixed width for the underline
                            color: authController.isLoginForm.value
                                ? Colors.black
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Container(
                    height: 2.h,
                    width: 1,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 4.w),
                  GestureDetector(
                    onTap: () {
                      authController.isLoginForm.value = false;
                      _pageController.animateToPage(1,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 6.w),
                          decoration: BoxDecoration(
                            color: !authController.isLoginForm.value
                                ? Colors.grey.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: !authController.isLoginForm.value
                                  ? Colors.black
                                  : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: 2,
                            width: 40.w, // Fixed width for the underline
                            color: !authController.isLoginForm.value
                                ? Colors.black
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
            SizedBox(
              height: 3.h,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  authController.isLoginForm.value = (index == 0);
                },
                children: [
                  LoginForm(),
                  SignUpForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
