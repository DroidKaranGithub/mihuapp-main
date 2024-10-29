import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/home-flow/buisness_personal/business_slider.dart';
import 'package:mihu/home-flow/greeting/contollers/future_greetings_controller.dart';
import 'package:mihu/home-flow/greeting/greetingSlider.dart';
import 'package:mihu/home-flow/greeting/widgets/set_new_greetings.dart';
import 'package:mihu/home-flow/home/controller/category_controller.dart';
import 'package:mihu/home-flow/home/controller/slidercontroller.dart';
import 'package:mihu/home-flow/home/elements/business_profile_header.dart';
import 'package:mihu/home-flow/home/elements/combined_carousel_widget.dart';
import 'package:mihu/home-flow/home/elements/gallery_upload_screen.dart';
import 'package:mihu/shared_widgets/buttons/crousel_button.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/add-greetings_future.dart';

class GreetingFutureScreen extends StatefulWidget {
  @override
  State<GreetingFutureScreen> createState() => _GreetingFutureScreenState();
}

class _GreetingFutureScreenState extends State<GreetingFutureScreen> {
  final CategoryController categoryController =
      Get.put(CategoryController(), permanent: true);
  final GreetingController greetingController =
      Get.put(GreetingController(), permanent: true);

  @override
  void initState() {
    super.initState();
    greetingController.getGreetingsTodayPost("3"); // Load default data
    greetingController.getGreetingsToday();

    // Select the first category by default
  }

  @override
  void dispose() {
    categoryController.resetCategory(); // Reset when leaving screen

    super.dispose();
  }

  Future<void> _onRefresh() async {
    // Refresh data
    // categoryController.selectedCategory.value = greetingController.festivalCatList[0].name;
    await greetingController.GreetingpostApi("1");
    await greetingController
        .getGreetingsFutureCategory(); // Optional: Refresh categories too
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
                  Text('Upload Greetings',
                      style: TextStyle(fontSize: 11.sp, color: Colors.black)),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(8.0)),
                    width: MediaQuery.of(context).size.width*0.4,
                    height: MediaQuery.of(context).size.width*0.12,
                    child: TextButton(
                        onPressed: () {
                          Get.to(() => NewGreetingPageFuture(
                              greetingController.greetingFutureCat));
                        },
                        child:Text('+ Set New Greetings',style: TextStyle( color: Colors.white),)
                    ),
                  ),

                  // Container(
                  //   decoration: BoxDecoration(
                  //       color: Colors.black,
                  //       borderRadius: BorderRadius.circular(8.0)),
                  //   width: MediaQuery.of(context).size.width * 0.4,
                  //   height: MediaQuery.of(context).size.width * 0.12,
                  //   child: TextButton(
                  //       onPressed: () {
                  //         // categoryController.resetCategory();
                  //         Get.to(() => NewGreetingPageFuture(
                  //             greetingController.greetingFutureCat));
                  //       },
                  //       child: Text(
                  //         '+ Set New Greetings',
                  //         style: TextStyle(color: Colors.white),
                  //       )),
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Obx(() {
                // Get the number of chips to display
                final displayCount = 3; // Change this to 2 or 3 as needed
                final displayedCategories = greetingController.greetingFutureCat
                    .take(displayCount)
                    .toList();

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for (var category in displayedCategories)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: categoryChip(category.name, category.id),
                        ),
                      Container(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
                          onTap: () => _showMoreCategories(context),
                          child: Chip(
                            backgroundColor: Colors.white,
                            label: Text('More +',
                                style: TextStyle(fontSize: 8.sp)),
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
                } else if (greetingController.posts.isEmpty) {
                  return Center(child: Text("No posts available."));
                } else {
                  // Create a repeating list of posts
                  final repeatedPosts = List.generate(
                    10, // Change this number to repeat the posts more or less
                        (index) => greetingController.posts[index % greetingController.posts.length],
                  );

                  return PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: greetingController.posts.length,
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
            greetingController.posts
                .clear(); // Clear the list before fetching new posts
            greetingController.GreetingpostApi(
                id.toString()); // Fetch new posts for the selected category
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
      isDismissible: true,
      // Ensure it's dismissible
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
                      for (var category in greetingController.greetingFutureCat)
                        GestureDetector(
                          onTap: () {
                            // Select the category and load posts
                            categoryController.selectCategory(category.name);
                            greetingController.GreetingpostApi(
                                category.id.toString());

                            // Close the bottom sheet
                            Navigator.pop(context);
                          },
                          child: categoryChip(category.name, category.id),
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
