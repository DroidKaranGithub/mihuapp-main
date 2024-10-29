// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mihu/shared_widgets/buttons/crousel_button.dart';
// import 'package:sizer/sizer.dart';
// import 'package:mihu/constrants/colors/colors.dart';
//
// class FutureGreetings extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColorWhite,
//       body: Padding(
//         padding: EdgeInsets.all(5.w),
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.all(5.w),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Happy Birthday',
//                         style: TextStyle(fontSize: 12.sp),
//                       ),
//                       Text(
//                         '1 May 2024',
//                         style: TextStyle(fontSize: 10.sp, fontStyle: FontStyle.italic),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 2.h),
//                   Column(
//                     children: [
//                       CircleAvatar(
//                         radius: 10.w,
//                         backgroundColor: Colors.grey[300],
//                         child: Icon(Icons.person, size: 15.w),
//                       ),
//                       SizedBox(height: 2.h),
//                       Text(
//                         'Entered Message text',
//                         style: TextStyle(fontSize: 12.sp, color: Colors.grey),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 2.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       CrouselButton(
//                         text: 'Edit',
//                         color: Colors.blueGrey,
//                         icon: Icon(Icons.edit, size: 6.w,color: Colors.white,),
//                         onPressed: () {
//                           // Handle Edit action
//                         },
//                       ),
//                       SizedBox(width: 2.w),
//                       CrouselButton(
//                         text: 'Delete',
//                         color: Colors.red,
//                         icon: Icon(Icons.delete, size: 6.w,color: Colors.white,),
//                         onPressed: () {
//                           // Handle Delete action
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/network/apiclient.dart/apicilent.dart';
import 'package:mihu/home-flow/greeting/contollers/future_greetings_controller.dart';
import 'package:mihu/shared_widgets/buttons/crousel_button.dart';
import 'package:sizer/sizer.dart';

class FutureGreetings extends StatelessWidget {
  final GreetingController festivalController = Get.put(GreetingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorWhite,
      body: Obx(() {
        if (festivalController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (festivalController.festivalCategories.isEmpty) {
          return Center(child: Text('No festivals available'));
        } else {
          return Padding(
            padding: EdgeInsets.all(5.w),
            child: ListView.builder(
              itemCount: festivalController.festivalCategories.length,
              itemBuilder: (context, index) {
                var festival = festivalController.festivalCategories[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Container(
                    padding: EdgeInsets.all(5.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              festival['name'] ?? 'N/A',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            Text(
                              festival['event_date'] ?? 'N/A',
                              style: TextStyle(fontSize: 10.sp, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 10.w,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: (festival['image'] != null && festival['image'].isNotEmpty)
                                  ? NetworkImage(festival['image'])
                                  : null,
                              child: (festival['image'] == null || festival['image'].isEmpty)
                                  ? Icon(Icons.person, size: 15.w)
                                  : null,
                            ),
                            SizedBox(height: 2.h),
                            TextField(
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: 'Enter Message Text',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CrouselButton(
                              text: 'Edit',
                              color: Colors.blueGrey,
                              icon: Icon(Icons.edit, size: 6.w, color: Colors.white),
                              onPressed: () {
                                // Handle Edit action
                              },
                            ),
                            SizedBox(width: 2.w),
                            CrouselButton(
                              text: 'Delete',
                              color: Colors.red,
                              icon: Icon(Icons.delete, size: 6.w, color: Colors.white),
                              onPressed: () {
                                // Handle Delete action
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      }),
    );
  }
}

