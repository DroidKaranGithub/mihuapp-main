import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/home-flow/add_user/add_user_screen.dart';
import 'package:mihu/home-flow/home/controller/category_controller.dart';
import 'package:mihu/home-flow/home/controller/home_slider_controller.dart';
import 'package:mihu/home-flow/home/controller/slidercontroller.dart';
import 'package:mihu/home-flow/home/elements/gallery_upload_screen.dart';
import 'package:mihu/home-flow/home/elements/profileheader.dart';
import 'package:sizer/sizer.dart';
import 'package:mihu/home-flow/home/elements/combined_carousel_widget.dart';
import '../../add_user/add_user_controller.dart';

class MyselfHome extends StatefulWidget {
  @override
  State<MyselfHome> createState() => _MyselfHomeState();
}

class _MyselfHomeState extends State<MyselfHome> {
  final CategoryController categoryController = Get.put(CategoryController(), permanent: true);
  final SliderController sliderController = Get.put(SliderController(), permanent: true);
  final AddUserController addUserController = Get.put(AddUserController());
  final HomeSliderController homeController = Get.put(HomeSliderController());

  bool showOverlay = false;

  @override
  void initState() {
    super.initState();
    sliderController.getFestivalPostById("23"); // Load default data
    sliderController.getFestivalCategory();
    fetchProfiles();

    // Select the first category by default
    if (sliderController.festivalCatList.isNotEmpty) {
      categoryController.selectedCategory.value = sliderController.festivalCatList[0].name;
    }

    ever(sliderController.businessCatList, (_) {
      if (sliderController.businessCatList.isNotEmpty) {
        final firstCategory = sliderController.businessCatList[0];
        categoryController.selectedCategory.value = firstCategory.name;
        sliderController.getBusinessPostById(firstCategory.id.toString());
      }
    });
  }

  Future<void> fetchProfiles() async {
    await addUserController.fetchAddUsers();
    setState(() {
      showOverlay = homeController.totalMyself == 0 || addUserController.defaultProfilesList.isEmpty;
    });
  }

  @override
  void dispose() {
    categoryController.resetCategory();  // Reset when leaving screen
    super.dispose();
  }

  Future<void> _onRefresh() async {
    // Refresh data
    categoryController.selectedCategory.value = sliderController.festivalCatList[0].name;
    await sliderController.getFestivalPostById("23");
    await sliderController.getFestivalCategory(); // Optional: Refresh categories too
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Stack(
          children: [
            Column(
              children: [
                ProfileHeader(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5.2.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Select Category', style: TextStyle(fontSize: 11.sp, color: Colors.black)),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8.0)),
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.12,
                        child: TextButton(
                          onPressed: () {
                            categoryController.resetCategory();
                            Get.to(() => GalleryUploadScreen());
                          },
                          child: Text('+ Gallery Upload', style: TextStyle(color: Colors.white)),
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
                    final displayedCategories = sliderController.festivalCatList.take(displayCount).toList();

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
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
                    if (sliderController.isPostLoading.value) {
                      return Center(child: SizedBox(child: CircularProgressIndicator()));
                    } else if (sliderController.errorMessage.isNotEmpty) {
                      return Center(child: Text(sliderController.errorMessage.value));
                    } else if (sliderController.posts.isEmpty) {
                      return Center(child: Text("No posts available."));
                    } else {
                      // Create a repeating list of posts
                      final repeatedPosts = List.generate(
                        10, // Change this number to repeat the posts more or less
                            (index) => sliderController.posts[index % sliderController.posts.length],
                      );

                      return PageView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: repeatedPosts.length,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return CombinedCarouselWidget(
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
            if (showOverlay)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.black.withOpacity(0.6),),
                child: Positioned.fill(
                  child: AlertDialog(
                    backgroundColor: Colors.white,
                    title: Center(child: Text('No profile found', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.add, color: Colors.grey[700]),
                          title: Text('Add Business'),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddUser()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
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
            sliderController.posts.clear(); // Clear the list before fetching new posts
            sliderController.getFestivalPostById(id.toString()); // Fetch new posts for the selected category
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
                      for (var category in sliderController.festivalCatList)
                        GestureDetector(
                          onTap: () {
                            // Select the category and load posts
                            categoryController.selectCategory(category.name);
                            sliderController.getFestivalPostById(category.id.toString());

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

