import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mihu/auth_workflow/widgets.dart/login.dart';

import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/network/apiclient.dart/apicilent.dart';

import 'package:mihu/shared_widgets/buttons/bottombutton.dart';
import 'package:mihu/shared_widgets/passwordinputfield/passwordfield.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class EditPassword extends StatefulWidget {
  @override
  _EditPasswordState createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final FocusNode mobileFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode repasswordFocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final ApiClient apiClient = ApiClient();
  final storage = GetStorage();




  Future<void> _updatePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final loggedInUserEmail = storage.read('email');

        // First, verify the old password
        final oldPasswordResponse = await apiClient.loginUser(loggedInUserEmail, oldPasswordController.text);

        if (oldPasswordResponse['status']) {
          // If old password is correct, try logging in with the new password to simulate update
          final newPasswordResponse = await apiClient.loginUser(loggedInUserEmail, newPasswordController.text);

          if (newPasswordResponse['status']) {
            // If login with the new password is successful, notify the user
            Get.snackbar('Success', 'Password updated successfully!');
            // Optionally, you may want to log the user out or refresh the session
            // For example:
            Get.offAll(() => LoginForm());
          } else {
            Get.snackbar('Error', 'Failed to log in with the new password.');
          }
        } else {
          Get.snackbar('Error', 'Old password is incorrect.');
        }
      } catch (e) {
        Get.snackbar('Error', e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColorWhite,
        title: Text("Edit Password"),
      ),
      backgroundColor:
      backgroundColorWhite, // Replace with primarybackgroundColor
      body: Padding(
        padding: EdgeInsets.all(4.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      SizedBox(height: 3.h),
                      Container(
                        width: 80.w, // Reduced width for the container
                        child: PasswordField(
                          headText: "Old Password",
                          controller: oldPasswordController,
                          focusNode: repasswordFocusNode,
                          hintText: "Enter old password",
                          enableVisibilityToggle: true,
                          nextFocusNode: repasswordFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter old password';
                            }
                            return null;
                          },
                        ),
                      ),



                      SizedBox(height: 3.h),

                      Container(
                        width: 80.w, // Reduced width for the container
                        child: PasswordField(
                          headText: "New Password",
                          controller: newPasswordController,
                          focusNode: repasswordFocusNode,
                          hintText: "Enter your new password",
                          enableVisibilityToggle: true,
                          nextFocusNode: repasswordFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your new password';
                            }
                            return null;
                          },
                        ),
                      ),


                      SizedBox(height: 3.h),
                      Container(
                        width: 80.w, // Reduced width for the container
                        child: PasswordField(
                          headText: "Confirm Password",
                          controller: confirmPasswordController,
                          focusNode: repasswordFocusNode,
                          hintText: "Enter same Password",
                          enableVisibilityToggle: true,
                          nextFocusNode: repasswordFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            } else if (value != passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 3.h),

                    ],
                  ),
                ),
              ),
              BottomButton(
                color: primarybuttonColor, // Replace with primarybuttonColor
                text: "Edit Password",
                onTap: () {
                  _updatePassword();

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}