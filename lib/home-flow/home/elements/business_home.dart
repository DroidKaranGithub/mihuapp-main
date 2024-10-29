import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/home-flow/add-business_user/add_business_screen.dart';
import 'package:mihu/home-flow/home/controller/home_slider_controller.dart';
import 'package:mihu/home-flow/home/controller/slidercontroller.dart';
import 'package:mihu/home-flow/home/elements/business_profile_header.dart';
import 'package:mihu/home-flow/home/elements/gallery_upload_screen.dart';
import 'package:sizer/sizer.dart';

import 'package:mihu/home-flow/home/controller/home_slider_controller.dart' as homeController;
import 'package:mihu/home-flow/home/elements/business_profile_header.dart';
import '../../buisness_personal/business_slider.dart';
import '../controller/category_controller.dart';

class BusinessHome extends StatefulWidget {
  @override
  State<BusinessHome> createState() => _BusinessHomeState();
}

class _BusinessHomeState extends State<BusinessHome> {
  final CategoryController categoryController = Get.put(CategoryController(), permanent: true);
  final SliderController sliderController = Get.put(SliderController(), permanent: true);
  final homeController = Get.put(HomeSliderController());
  bool showOverlay = false;

  @override
  void initState() {
    super.initState();

    // Fetch business categories and posts
    sliderController.getBusinessCategory();
    sliderController.getBusinessPostById("18");

    // Select the first category by default
    ever(sliderController.businessCatList, (_) {
      if (sliderController.businessCatList.isNotEmpty) {
        final firstCategory = sliderController.businessCatList[0];
        categoryController.selectedCategory.value = firstCategory.name;
        sliderController.getBusinessPostById(firstCategory.id.toString());
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (homeController.totalBusiness == 0) {
        setState(() {
          showOverlay = true;
        });
      }
    });
  }

  Future<void> _onRefresh() async {
    // Refresh data
    categoryController.selectedCategory.value = ""; // Reset the selected category
    await sliderController.getBusinessPostById("18");
    await sliderController.getBusinessCategory(); // Refresh categories
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(color: Colors.white, child: BusinessProfileHeader()),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.2.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Select Category', style: TextStyle(fontSize: 12.sp, color: Colors.black)),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Get.to(() => GalleryUploadScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[850],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text('+ Gallery Upload', style: TextStyle(fontSize: 12.sp, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  if (sliderController.isCatLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Wrap(
                        spacing: 8.0,
                        children: [
                          for (var category in sliderController.businessCatList)
                            categoryChip(category.name, category.id),
                          GestureDetector(
                            onTap: () => _showMoreCategories(context),
                            child: Chip(
                              backgroundColor: Colors.white,
                              label: Text('More +', style: TextStyle(fontSize: 8.sp)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }),
                Expanded(
                  child: Obx(() {
                    if (sliderController.isPostLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    } else if (sliderController.errorMessage.isNotEmpty) {
                      return Center(child: Text(sliderController.errorMessage.value));
                    } else {
                      return Stack(
                        children: [
                          PageView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: sliderController.businPosts.length,
                            itemBuilder: (context, index) {
                              return BusinessCombinedCarouselWidget(
                                showEditButttom: true,
                                post: sliderController.businPosts[index],
                              );
                            },
                          ),
                          // Show overlay when needed

                        ],
                      );
                    }
                  }),
                ),
              ],
            ),
            if (showOverlay)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.black.withOpacity(0.6), ),
                // Semi-transparent overlay
                child:  Positioned.fill(

                  child: AlertDialog(

                    backgroundColor: Colors.white,
                    title: Center(child: Text('No Business Profile Found',style: TextStyle(fontSize: 12.sp,),)),
                    content:
                    Column(

                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.add, color: Colors.grey[700]),
                          title: Text('Add Business'),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddBusinessScreen()));
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
            categoryController.selectCategory(category); // Select category
            sliderController.getBusinessPostById(id.toString()); // Load posts for the selected category
          }
        },
        child: Chip(
          backgroundColor: isSelected ? Colors.grey : Colors.white,
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
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<SliderController>(builder: (controller) {
          return Container(
            decoration: BoxDecoration(
              color: backgroundColorWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            width: double.infinity,
            padding: EdgeInsets.all(10),
            height: 40.h,
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Text(
                  'Select Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Wrap(
                  spacing: 8.0,
                  children: [
                    for (var category in sliderController.businessCatList)
                      categoryChip(category.name, category.id),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }
}

