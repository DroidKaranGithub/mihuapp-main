import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/shared_widgets/buttons/bottombutton.dart';
import 'package:sizer/sizer.dart';
import '../controllers/signup_controller.dart';
import 'package:otpless_flutter/otpless_flutter.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController(); // OTP Controller

  final FocusNode mobileFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isOtpVisible = false; // Control OTP field visibility
  bool _isMobileLogin = true; // Control which input to show (mobile or email)
  final Otpless _otpless = Otpless(); // Create Otpless instance

  @override
  Widget build(BuildContext context) {
    final signupController = Get.put(SignupController());

    return Scaffold(
      backgroundColor: primarybackgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss the keyboard
        },
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNameField(signupController),
                  SizedBox(height: 3.h),
                  _buildEmailOrMobileField(signupController),
                  if (_isMobileLogin && _isOtpVisible) ...[
                    SizedBox(height: 2.h),
                    _buildOtpField(),
                  ],
                  SizedBox(height: 3.h),
                  _buildPasswordField(signupController),
                  SizedBox(height: 3.h),
                  _buildConfirmPasswordField(signupController),
                  SizedBox(height: 3.h),
                  BottomButton(
                    color: primarybuttonColor,
                    text: "Signup",
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        signupController.registerUser(
                          nameController.text,
                          emailController.text,
                          mobileController.text,
                          passwordController.text,
                          confirmPasswordController.text,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailOrMobileField(SignupController signupController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Use", style: TextStyle(color: Colors.black, fontSize: 14.sp)),
            Row(
              children: [
                Text("Email", style: TextStyle(color: Colors.black, fontSize: 14.sp)),
                Switch(
                  value: !_isMobileLogin,
                  onChanged: (value) {
                    setState(() {
                      _isMobileLogin = !value; // Toggle between mobile and email
                      if (_isMobileLogin) {
                        emailController.clear(); // Clear email input if switching to mobile
                      } else {
                        mobileController.clear(); // Clear mobile input if switching to email
                      }
                    });
                  },
                ),
                Text("Mobile", style: TextStyle(color: Colors.black, fontSize: 14.sp)),
              ],
            ),
          ],
        ),
        SizedBox(height: 1.h),
        if (_isMobileLogin) ...[
          _buildMobileField(signupController),
          TextButton(
            onPressed: () async {
              if (mobileController.text.isEmpty || mobileController.text.length != 10) {
                Get.snackbar("Error", "Please enter a valid mobile number for signup with OTP",
                    snackPosition: SnackPosition.BOTTOM);
              } else {
                await _startHeadlessForPhoneAndEmail(mobileController.text);
              }
            },
            child: Text(
              _isOtpVisible ? "Hide OTP Field" : "Login with OTP",
              style: TextStyle(color: Colors.blue, fontSize: 14.sp),
            ),
          ),
        ] else ...[
          _buildEmailField(signupController),
        ],
      ],
    );
  }

  Future<void> _startHeadlessForPhoneAndEmail(String mobile) async {
    try {
      // Call your method to start headless operation for OTP
      // final response = await _otpless.startHeadlessForPhoneAndEmail(mobile, emailController.text); // Adjust method parameters as needed
      // if (response.success) {
      //   setState(() {
      //     _isOtpVisible = true; // Show the OTP field after sending the OTP
      //   });
      //   Get.snackbar("Success", "OTP sent successfully!", snackPosition: SnackPosition.BOTTOM);
      // } else {
      //   Get.snackbar("Error", response.message, snackPosition: SnackPosition.BOTTOM);
      // }
    } catch (e) {
      Get.snackbar("Error", "Failed to send OTP. Please try again.", snackPosition: SnackPosition.BOTTOM);
    }
  }

  Widget _buildOtpField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("OTP", style: TextStyle(color: Colors.black, fontSize: 14.sp)),
        SizedBox(height: 1.h),
        TextFormField(
          controller: otpController,
          decoration: InputDecoration(
            hintText: "Enter OTP",
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your OTP";
            } else if (value.length != 6) {
              return "OTP must be 6 digits";
            }
            return null;
          },
        ),
      ],
    );
  }


  Widget _buildNameField(SignupController signupController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 2.w),
          child: Text(
            "Name",
            style: TextStyle(color: Colors.black, fontSize: 14.sp),
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: nameController,
          focusNode: nameFocusNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(emailFocusNode);
          },
          decoration: InputDecoration(
            hintText: "Enter Name",
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your name";
            } else if (value.length < 2) {
              return "Name must be at least 2 characters";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildEmailField(SignupController signupController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Email", style: TextStyle(color: Colors.black, fontSize: 14.sp)),
        SizedBox(height: 1.h),
        TextFormField(
          controller: emailController,
          focusNode: emailFocusNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(mobileFocusNode);
          },
          decoration: InputDecoration(
            hintText: "Enter Email",
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your email";
            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return "Please enter a valid email address";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildMobileField(SignupController signupController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Mobile Number", style: TextStyle(color: Colors.black, fontSize: 14.sp)),
        SizedBox(height: 1.h),
        TextFormField(
          controller: mobileController,
          focusNode: mobileFocusNode,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: "Enter Mobile Number",
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your mobile number";
            } else if (value.length != 10) {
              return "Mobile number must be 10 digits";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField(SignupController signupController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Password", style: TextStyle(color: Colors.black, fontSize: 14.sp)),
        SizedBox(height: 1.h),
        TextFormField(
          controller: passwordController,
          focusNode: passwordFocusNode,
          obscureText: !_isPasswordVisible,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
          },
          decoration: InputDecoration(
            hintText: "Enter Password",
            hintStyle: const TextStyle(color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your password";
            } else if (value.length < 6) {
              return "Password must be at least 6 characters";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField(SignupController signupController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Confirm Password", style: TextStyle(color: Colors.black, fontSize: 14.sp)),
        SizedBox(height: 1.h),
        TextFormField(
          controller: confirmPasswordController,
          focusNode: confirmPasswordFocusNode,
          obscureText: !_isConfirmPasswordVisible,
          decoration: InputDecoration(
            hintText: "Confirm Password",
            hintStyle: const TextStyle(color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please confirm your password";
            } else if (value != passwordController.text) {
              return "Passwords do not match";
            }
            return null;
          },
        ),
      ],
    );
  }
}
