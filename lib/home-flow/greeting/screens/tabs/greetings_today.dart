import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/home-flow/add_user/add_user_controller.dart';
import 'package:mihu/home-flow/greeting/contollers/future_greetings_controller.dart';
import 'package:mihu/home-flow/greeting/greetingSlider.dart';
import 'package:mihu/home-flow/greeting/widgets/set_new_greetings.dart';
import 'package:mihu/home-flow/home/controller/category_controller.dart';
import 'package:mihu/home-flow/home/controller/slidercontroller.dart';
import 'package:mihu/home-flow/home/elements/gallery_upload_screen.dart';
import 'package:mihu/home-flow/home/elements/profileheader.dart';
import 'package:mihu/shared_widgets/buttons/crousel_button.dart';
import 'package:mihu/shared_widgets/buttons/customvtn.dart';
import 'package:sizer/sizer.dart';
import 'package:mihu/home-flow/home/elements/combined_carousel_widget.dart';

class GreetingTodayScreen extends StatefulWidget {
  @override
  State<GreetingTodayScreen> createState() => _GreetingTodayScreenState();
}

class _GreetingTodayScreenState extends State<GreetingTodayScreen> {
  final CategoryController categoryController = Get.put(CategoryController(), permanent: true);
  final GreetingController greetingController = Get.put(GreetingController(), permanent: true);

  @override
  void initState() {
    super.initState();
    greetingController.getGreetingsTodayPost("3"); // Load default data
    greetingController.getGreetingsToday();

    // Select the first category by default
    if (greetingController.greetingTodayList.isNotEmpty) {
      categoryController.selectedCategory.value = greetingController.greetingTodayList[0].name;
    }
  }

  @override
  void dispose() {
    categoryController.resetCategory();  // Reset when leaving screen

    super.dispose();
  }

  Future<void> _onRefresh() async {
    // Refresh data
    // categoryController.selectedCategory.value = greetingController.festivalCatList[0].name;
    await greetingController.getGreetingsTodayPost("1");
    await greetingController.getGreetingsToday(); // Optional: Refresh categories too
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5.2.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Upload Greetings', style: TextStyle(fontSize: 11.sp, color: Colors.black)),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(8.0)),
                    width: MediaQuery.of(context).size.width*0.4,
                    height: MediaQuery.of(context).size.width*0.12,
                    child: TextButton(
                        onPressed: () {
                          Get.to(() => NewGreetingPage(greetingController.greetingTodayList));

                        },
                        child:Text('+ Set New Greetings',style: TextStyle( color: Colors.white),)
                    ),
                  ),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Obx(() {
                // Get the number of chips to display
                final displayCount = 3; // Change this to 2 or 3 as needed
                final displayedCategories = greetingController.greetingTodayList.take(displayCount).toList();

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var category in displayedCategories)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: categoryChip(category.name, category.greetingSectionId),
                        ),
                      if(displayedCategories.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
                          onTap: () => _showMoreCategories(context),
                          child: Chip(
                            backgroundColor: Colors.white,
                            label: Text('More +', style: TextStyle(fontSize: 8.sp)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),

            Expanded(
              child: Obx(() {
                if (greetingController.isGreetingTodayPostLoading.value) {
                  return Center(child: SizedBox(child: CircularProgressIndicator()));
                } else if (greetingController.errorMessage.isNotEmpty) {
                  return Center(child: Text(greetingController.errorMessage.value));
                } else if (greetingController.greetingTodayListPost.isEmpty) {
                  return Center(child: Text("No posts available."));
                } else {
                  // Create a repeating list of posts
                  final repeatedPosts = List.generate(
                    10, // Change this number to repeat the posts more or less
                        (index) => greetingController.greetingTodayListPost[index % greetingController.greetingTodayListPost.length],
                  );

                  return PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: greetingController.greetingTodayListPost.length,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GallerySliderWidget(
                        showEditButttom: true,
                        post: repeatedPosts[index],
                      );
                    },
                  );
                }
              }),
            ),

            /*   Expanded(
              child: Obx(() {
                if (greetingController.isGreetingTodayPostLoading.value) {
                  return Center(child: SizedBox(child: CircularProgressIndicator()));
                } else if (greetingController.errorMessage.isNotEmpty) {
                  return Center(child: Text(greetingController.errorMessage.value));
                } else if (greetingController.greetingTodayListPost.isEmpty) {
                  return Center(child: Text("No Greetings available. You can set New."));
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: greetingController.greetingTodayListPost.length,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        height: MediaQuery.of(context).size.height*0.35,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 01.h),
                          child: Container(
                            padding: EdgeInsets.all(3.w),
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
                              mainAxisSize: MainAxisSize.min, // Only take as much space as needed
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        greetingController.greetingTodayListPost[index].message ?? 'N/A',
                                        style: TextStyle(fontSize: 12.sp),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      greetingController.greetingTodayListPost[index].date ?? 'N/A',
                                      style: TextStyle(fontSize: 10.sp, fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1.h), // Reduced space between elements
                                Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 20.w,
                                      backgroundColor: Colors.grey[300],
                                      backgroundImage: (greetingController.greetingTodayListPost[index].photo != null && greetingController.greetingTodayListPost[index].photo.isNotEmpty)
                                          ? NetworkImage(greetingController.greetingTodayListPost[index].photo)
                                          : null,
                                      child: (greetingController.greetingTodayListPost[index].photo == null || greetingController.greetingTodayListPost[index].photo.isEmpty)
                                          ? Icon(Icons.person, size: 15.w)
                                          : null,
                                    ),
                                    SizedBox(height: 1.h), // Adjusted space
                                  ],
                                ),
                                SizedBox(height: 1.h), // Adjusted space before buttons
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
                        ),
                      );
                    },
                  );
                }
              }),
            ),*/

          ],
        ),
      ),
    );
  }

  Widget categoryChip(String category, int id) {
    return Obx(() {
      bool isSelected = categoryController.selectedCategory.value == category;

      return GestureDetector(
        onTap: () {
          if (!isSelected) {
            categoryController.selectCategory(category);
            greetingController.greetingTodayListPost.clear(); // Clear the list before fetching new posts
            greetingController.getGreetingsTodayPost(id.toString()); // Fetch new posts for the selected category
          }
        },
        child: Chip(
          backgroundColor: isSelected ? const Color(0xFFA2DED0) : Colors.white,
          label: Text(category, style: TextStyle(fontSize: 8.sp)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      );
    });
  }

  void _showMoreCategories(BuildContext context) {
    showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      isDismissible: true,  // Ensure it's dismissible
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<CategoryController>(
          builder: (controller) {
            return Container(
              decoration: const BoxDecoration(
                color: backgroundColorWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              height: 70.h,
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.only(top: 8, bottom: 40),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const Text(
                    'Select Category',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      for (var category in greetingController.greetingTodayList)
                        GestureDetector(
                          onTap: () {
                            // Select the category and load posts
                            categoryController.selectCategory(category.name);
                            greetingController.getGreetingsTodayPost(category.greetingSectionId.toString());

                            // Close the bottom sheet
                            Navigator.pop(context);
                          },
                          child: categoryChip(category.name, category.greetingSectionId),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
