import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:image_picker/image_picker.dart';

class UploadPhoto extends StatefulWidget {
  String imageFile;
   UploadPhoto({super.key,required this.imageFile});

  @override
  UploadPhotoState createState() => UploadPhotoState();
}

class UploadPhotoState extends State<UploadPhoto> {
  final ImagePicker _picker = ImagePicker();
  XFile? imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
      _isLoading = true;
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
          imageFile = pickedFile;
      }
    } catch (e) {
      // Handle errors if any
    } finally {
        _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 2.h),
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 22.w,
                height: 22.w, // Ensuring circular shape
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                child: ClipOval(
                  child: imageFile == null
                      ? Image.asset(
                          'assets/icons/profilemain.png',
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(imageFile!.path),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              if (_isLoading)
                Center(
                  child: Lottie.asset('assets/loading.json',
                      repeat: true, animate: true, width: 40),
                ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Upload Photo',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}