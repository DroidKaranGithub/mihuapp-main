import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ProfilePhotoController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  Rx<XFile?> imageFile = Rx<XFile?>(null);
  RxBool isLoading = false.obs;
  Rx<Uint8List?> image = Rx<Uint8List?>(null);


  Future<void> pickImage() async {
    isLoading.value = true;
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final croppedFile = await _cropImage(pickedFile);
        if (croppedFile != null) {
          imageFile.value = croppedFile;
        }
      }
    } catch (e) {
      // Handle errors if any
    } finally {
      isLoading.value = false;
    }
  }

  Future<XFile?> _cropImage(XFile imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          lockAspectRatio: false,
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      ],
    );
    return croppedFile != null ? XFile(croppedFile.path) : null;
  }


  Future<void> removeBackground() async {
    if (imageFile.value != null) {
      isLoading.value = true;
      try {
        // Load the image file
        final inputFile = File(imageFile.value!.path);

        // Convert the image to Uint8List (bytes)
        final Uint8List imageBytes = await inputFile.readAsBytes();

        // Process the image to remove the background
        image.value = null;

      } catch (e) {
        // Handle errors if any
        print("Error removing background: $e");
      } finally {
        isLoading.value = false;
      }
    }
  }

}
