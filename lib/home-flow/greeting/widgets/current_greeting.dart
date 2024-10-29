// import 'package:flutter/material.dart';
// import 'package:mihu/home-flow/greeting/widgets/set_new_greetings.dart';
// import 'package:mihu/home-flow/home/controller/slidercontroller.dart';
// import 'package:mihu/home-flow/home/elements/combined_carousel_widget.dart';
// import 'package:sizer/sizer.dart';
// import 'package:get/get.dart';
// import 'package:mihu/home-flow/home/controller/category_controller.dart';
//
// import 'package:mihu/constrants/colors/colors.dart';
//
//
// class CurrentGreeting extends StatelessWidget {
//   final CategoryController categoryController = Get.put(CategoryController(), permanent: true);
//   final SliderController sliderController = Get.put(SliderController(), permanent: true);
//
//
//   @override
//   Widget build(BuildContext context) {
//     // final List<MediaItem> mediaItems = [
//     //   MediaItem(path: 'assets/images/crouselposttwo.jpg', isImage: true),
//     //   MediaItem(path: 'assets/videos/sample1.mp4', isImage: false), // Sample video
//     // ];
//
//     return Scaffold(
//       backgroundColor: Color(0xFFF9F9F9),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 8.w),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Select Category', style: TextStyle(fontSize: 12.sp, color: Colors.black)),
//                   ElevatedButton(
//                     onPressed: () {
//                       Get.to(() => NewGreetingPage( controller.greetingCatList));
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.grey[850],
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                     ),
//                     child: Text('Set New Greeting', style: TextStyle(fontSize: 12.sp, color: Colors.white)),
//                   ),
//                 ],
//               ),
//             ),
//             Wrap(
//               spacing: 3.0,
//               children: [
//                 categoryChip('Good Night'),
//                 categoryChip('Motivation'),
//                 categoryChip('Shyam Baba'),
//                 categoryChip('Good Morning'),
//                 categoryChip('God'),
//                 GestureDetector(
//                   onTap: () => _showMoreCategories(context),
//                   child: Chip(
//                     backgroundColor: Colors.white,
//                     label: Text('More +'),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             // CombinedCarouselWidget(showEditButttom:  true,),
//             // Obx(() {
//             //   if (sliderController.isLoading.value) {
//             //     return Center(child: CircularProgressIndicator());
//             //   } else if (sliderController.errorMessage.isNotEmpty) {
//             //     return Center(child: Text(sliderController.errorMessage.value));
//             //   } else if (sliderController.mediaItems.isEmpty) {
//             //     return Center(child: Text("No media available"));
//             //   } else {
//             //     return Column(
//             //       children: List.generate(sliderController.mediaItems.length, (index) {
//             //         return CombinedCarouselWidget(id: sliderController.mediaItems[index].id);
//             //       }),
//             //     );
//             //   }
//             // }),
//             //
//
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget categoryChip(String category) {
//     return Obx(() {
//       return GestureDetector(
//         onTap: () => categoryController.selectCategory(category),
//         child: Chip(
//           backgroundColor: categoryController.selectedCategory.value == category
//               ? Color(0xFFA2DED0)
//               : Colors.white,
//           label: Text(category,style: TextStyle(fontSize: 8.sp)),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(18),
//           ),
//         ),
//       );
//     });
//   }
//   void _showMoreCategories(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     builder: (BuildContext context) {
//       return GetBuilder<CategoryController>(
//         builder: (controller) {
//           return Container(
//             decoration: BoxDecoration(
//               color: backgroundColorWhite,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//             ),
//             width: double.infinity,
//             padding: EdgeInsets.all(10),
//             height: 40.h,
//             child: Column(
//               children: [
//                 Container(
//                   width: 50,
//                   height: 5,
//                   decoration: BoxDecoration(
//                     color: Colors.grey,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Select Category',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Wrap(
//                   spacing: 8.0,
//                   children: [
//                     categoryChip('Good Night'),
//                     categoryChip('Birthday Wishes'),
//                     categoryChip('Wishes'),
//                     categoryChip('Good Evening'),
//                     categoryChip('Festival'),
//                     categoryChip('Travel'),
//                     categoryChip('Event'),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     },
//   );
// }
//
// }
