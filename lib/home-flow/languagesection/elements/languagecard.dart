// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
//
// class LanguageCard extends StatelessWidget {
//   final String language;
//   final VoidCallback onTap;
//   final bool isSelected;
//
//   const LanguageCard({
//     Key? key,
//     required this.language,
//     required this.onTap,
//     this.isSelected = false,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 70.w,
//         height: 15.h,
//         padding: EdgeInsets.symmetric(vertical: 3.h),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.teal[100] : Colors.teal[50],
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Center(
//           child: Text(
//             language,
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 18.sp, color: Colors.black),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LanguageCard extends StatelessWidget {
  final String image;
  final String language;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageCard({
    Key? key,
    required this.image,
    required this.language,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double containerSize = 15.h;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: containerSize,
        width: containerSize,
        padding: EdgeInsets.all(2.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal[100] : Colors.teal[50],
          borderRadius: BorderRadius.circular(2.h),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius:4,
              offset: const Offset(0, 3),
            ),
          ],

        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.network(
            //   image,
            //   height: 12.h, // Adjust the height as needed
            //   width: 12.h,  // Adjust the width as needed
            //   fit: BoxFit.cover,
            // ),
            SizedBox(height: 1.h),
            Text(
              language,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

