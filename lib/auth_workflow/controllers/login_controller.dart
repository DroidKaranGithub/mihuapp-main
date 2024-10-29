import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mihu/network/apiclient.dart/apicilent.dart';
import 'package:mihu/home-flow/home/screen/homescreen.dart';
import 'package:mihu/home-flow/profile/controller/profile_controller.dart';
import 'package:mihu/network/models/profile_model.dart';

class LoginController extends GetxController {
  final storage = GetStorage();
  var isLoading = false.obs;
  final ProfileController profileController = Get.put(ProfileController());

  Future<void> clearUserData() async {
    try {
      // Clear all user-related data
      await storage.erase(); // This clears all data stored in GetStorage
      // Alternatively, if you only want to remove specific keys, use:
      // await storage.remove('userProfile');
      // await storage.remove('isLoggedIn');
      // await storage.remove('profilePic');
      // await storage.remove('name');
      // await storage.remove('phone');

      // Optionally update the ProfileController to reset profile data
      Get.find<ProfileController>().setProfileData( null);

      Get.snackbar('Success', 'Logged out successfully',colorText: Colors.white,backgroundColor: Colors.black);
    } catch (e) {
      Get.snackbar('Error', 'Error clearing user data: $e',colorText: Colors.white,backgroundColor: Colors.black);
    }
  }

  Future<void> loginUser(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please enter both email and password',colorText: Colors.white,backgroundColor: Colors.black);
      return;
    }

    isLoading(true);
    try {
      final response = await ApiClient().loginUser(email, password);

      if (response['status'] == true) {
        // Extract token and user data from response
        String accessToken = response['access_token'];
        final profileData = Profile.fromJson(response['data']);

        // Log extracted token to check if it's correct
        log('Access Token: $accessToken');

        // Ensure token is not null or empty
        if (accessToken.isNotEmpty) {
          // Store user data and token in GetStorage
          storage.write('userProfile', response['data']);
          storage.write('accessToken', accessToken);
          storage.write('isLoggedIn', true);
          storage.write('profilePic', profileData.profilePic);
          storage.write('name', profileData.name);
          storage.write('phone', profileData.phone);

          // Verify stored token and user data
          log('Stored Access Token: ${storage.read('accessToken')}');
          log('Stored Name: ${storage.read('name')}');
          log('Stored Phone: ${storage.read('phone')}');

          // Update profile data in ProfileController
          profileController.setProfileData(profileData);

          // Navigate to the HomePage
          Get.offAll(() => HomePage());

          // Fetch profile data after navigation
          profileController.fetchProfile();
          update();

          // Show success message
          Get.snackbar('', response['message'] ?? 'Login successful',colorText: Colors.white,backgroundColor: Colors.black);
        } else {
          // Show an error if token is null or empty
          Get.snackbar('Error', 'Token is missing from the response',colorText: Colors.white,backgroundColor: Colors.black);
        }
      } else {
        // Show error message from response
        Get.snackbar('Error', response['message'] ?? 'Login failed',colorText: Colors.white,backgroundColor: Colors.black);
      }
    } catch (e) {
      // Handle any other errors
      Get.snackbar('Error', 'An error occurred during login: $e',colorText: Colors.white,backgroundColor: Colors.black);
      log('Login Error: $e');
    } finally {
      isLoading(false);
    }
  }
}
