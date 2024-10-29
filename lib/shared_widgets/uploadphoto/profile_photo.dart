// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:sizer/sizer.dart';
// import 'package:image_picker/image_picker.dart';
//
//
// class ProfilePhoto extends StatefulWidget {
//   final String? profilePic;
//
//   const ProfilePhoto({super.key, this.profilePic});
//
//   @override
//   ProfilePhotoState createState() => ProfilePhotoState();
// }
//
// class ProfilePhotoState extends State<ProfilePhoto> {
//   final ImagePicker _picker = ImagePicker();
//   XFile? _imageFile;
//   bool _isLoading = false;
//
//   Future<void> _pickImage() async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//       if (pickedFile != null) {
//         setState(() {
//           _imageFile = pickedFile;
//         });
//       }
//     } catch (e) {
//       // Handle errors if any
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(height: 2.h),
//         GestureDetector(
//           onTap: _pickImage,
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               Container(
//                 width: 22.w,
//                 height: 22.w, // Ensuring circular shape
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.grey[200],
//                 ),
//                 child: ClipOval(
//                   child: _imageFile != null
//                       ? Image.file(
//                     File(_imageFile!.path),
//                     fit: BoxFit.cover,
//                   )
//                       : (widget.profilePic != null && widget.profilePic!.isNotEmpty)
//                       ? Image.network(
//                     widget.profilePic!,
//                     fit: BoxFit.cover,
//                   )
//                       : Image.asset(
//                     'assets/icons/profilemain.png',
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               if (_isLoading)
//                 Center(
//                   child: Lottie.asset('assets/loading.json',
//                       repeat: true, animate: true, width: 40),
//                 ),
//             ],
//           ),
//         ),
//         SizedBox(height: 1.h),
//         Text(
//           'Edit Photo',
//           style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mihu/home-flow/profile/controller/profile_photo_controller.dart';
import 'package:sizer/sizer.dart';


class ProfilePhoto extends StatelessWidget {
  final String? profilePic;
  final ProfilePhotoController controller = Get.put(ProfilePhotoController());

  ProfilePhoto({super.key, this.profilePic});

  Widget _buildProfileImage() {
    return Obx(() {
      if (controller.imageFile.value != null) {
        return Image.file(
          File(controller.imageFile.value!.path),
          fit: BoxFit.cover,
        );
      } else if (profilePic != null && profilePic!.isNotEmpty) {
        return Image.network(
          profilePic!,
          fit: BoxFit.cover,
        );
      } else {
        return Image.asset(
          'assets/icons/profilemain.png',
          fit: BoxFit.cover,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 2.h),
        GestureDetector(
          onTap: controller.pickImage,
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
                  child: _buildProfileImage(),
                ),
              ),
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: Lottie.asset('assets/loading.json',
                        repeat: true, animate: true, width: 40),
                  );
                } else {
                  return SizedBox.shrink();
                }
              }),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Edit Photo',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
