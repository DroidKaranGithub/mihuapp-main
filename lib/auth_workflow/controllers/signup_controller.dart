import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mihu/home-flow/languagesection/screens/language.dart';
import 'package:mihu/network/apiclient.dart/apicilent.dart';
import 'package:mihu/home-flow/languagesection/screens/language.dart';
import 'package:mihu/home-flow/profile/controller/profile_controller.dart';
import 'package:mihu/network/models/profile_model.dart';

import '../../home-flow/profile/controller/profile_controller.dart';

class SignupController extends GetxController {
  final storage = GetStorage();
  var isLoading = false.obs;

  String tokenGet = "";
  String emailText = "";
  String phoneText = "";

  var nameError = ''.obs;
  var emailError = ''.obs;
  var mobileError = ''.obs;
  var passwordError = ''.obs;
  var confirmPasswordError = ''.obs;

  Future<void> clearUserData() async {
    try {
      await storage.erase(); // Clears all data stored in GetStorage
      await storage.remove('userProfile');
      await storage.remove('isLoggedIn');
      await storage.remove('profilePic');
      await storage.remove('name');
      await storage.remove('phone');

      // Reset profile data in ProfileController
      Get.find<ProfileController>().setProfileData(null);
      Get.snackbar('Success', 'Logged out successfully',colorText: Colors.white,backgroundColor: Colors.black);
    } catch (e) {
      Get.snackbar('Error', 'Error clearing user data: $e',colorText: Colors.white,backgroundColor: Colors.black);
    }
  }

  Future<void> registerUser(String name, String email, String phone, String password, String confirmPassword) async {
    // Clear previous errors
    _clearErrors();

    // Validate inputs
    if (!_validateInputs(name, email, phone, password, confirmPassword)) {
      return;
    }

    // Proceed with registration logic (API call, etc.)
    isLoading(true);
    try {
      final response = await ApiClient().registerUser(name, email, phone, password);

      if (response['status']) {
        Get.snackbar('Success', 'Registration successful!',colorText: Colors.white,backgroundColor: Colors.black);
        storage.write('accessToken', response['access_token']);

        // Navigate to the next screen
        Get.offAll(() => LanguageSelectionPage());

        // Save user profile data
        final profileData = Profile.fromJson(response['data']);
        storage.write('userProfile', response['data']);
        storage.write('isLoggedIn', true);
        storage.write('profilePic', profileData.profilePic);
        storage.write('name', profileData.name);
        storage.write('phone', profileData.phone);

        Get.find<ProfileController>().setProfileData(profileData);
        Get.snackbar('Error', response['message'],colorText: Colors.white,backgroundColor: Colors.black);
            } else {
        Get.snackbar('Error', response['message'] ?? 'An error occurred during registration',colorText: Colors.white,backgroundColor: Colors.black);
      }
    } catch (e) {
      // Get.snackbar('Error', 'An unexpected error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  // Clears error messages
  void _clearErrors() {
    nameError.value = '';
    emailError.value = '';
    mobileError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
  }

  // Validate input fields
  bool _validateInputs(String name, String email, String phone, String password, String confirmPassword) {
    bool isValid = true;

    // Name Validation
    if (name.isEmpty) {
      nameError.value = 'Please enter your name';
      isValid = false;
    } else if (name.length < 2 || name.length > 30) {
      nameError.value = 'Name must be between 2 and 30 characters';
      isValid = false;
    }

    // Email Validation
    if (email.isEmpty) {
      emailError.value = 'Please enter your email';
      isValid = false;
    } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(email)) {
      emailError.value = 'Please enter a valid email address';
      isValid = false;
    }

    // Phone Validation
    if (phone.isEmpty) {
      mobileError.value = 'Please enter your mobile number';
      isValid = false;
    } else if (phone.length != 10 || !RegExp(r'^\d{10}$').hasMatch(phone)) {
      mobileError.value = 'Mobile number must be exactly 10 digits';
      isValid = false;
    }

    // Password Validation
    if (password.isEmpty) {
      passwordError.value = 'Please enter your password';
      isValid = false;
    } else if (password.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      isValid = false;
    }

    // Confirm Password Validation
    if (confirmPassword.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
      isValid = false;
    } else if (confirmPassword != password) {
      confirmPasswordError.value = 'Passwords do not match';
      isValid = false;
    }

    return isValid;
  }
}
