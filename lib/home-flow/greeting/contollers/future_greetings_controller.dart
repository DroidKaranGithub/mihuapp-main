import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mihu/home-flow/greeting/greeting_model.dart';
import 'package:mihu/home-flow/greeting/today_greeting_post_model.dart';
import 'package:mihu/home-flow/home/controller/category_controller.dart';
import 'package:mihu/network/apiclient.dart/apicilent.dart';
import 'package:mihu/home-flow/greeting/today%20GreetingsModel.dart';

import '../../../check_internet.dart';
import '../greetings_category_model.dart';

class GreetingController extends GetxController {
  var festivalCategories = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var selectedCategory = ''.obs;
  RxBool Business = true.obs;


  @override
  void onInit() {
    super.onInit();
    ever(greetingFutureCat, (_) {
      if (greetingFutureCat.isNotEmpty) {
        selectedCategory.value = greetingFutureCat.first.name;
        GreetingpostApi(greetingFutureCat.first.id.toString());
      }
    });    getGreetingsFutureCategory( );
     getGreetingsToday( );
  }


  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  var posts = <GreetingFuturePost>[].obs; // Change this to RxList
  var isGreetingLoading = false.obs;
  var errorMessage = "".obs;


  Future<void> GreetingpostApi(String id) async {
    isGreetingLoading(true);
    try {
      final response = await ApiClient().getGreetingPost(id);
      if (response['status']) {
        // Map the response to BusinessCatModel
        final businessCatModel = GreetingResponseModel.fromJson(response);

        // Clear the current list before adding new data
        posts.clear();

        // Add new items to the observable list
        posts.addAll(businessCatModel.data); // Use addAll here

        print("future Data:");
        print(posts.first.photo); // Print the observable list
      } else {
        // Get.snackbar('Error', response['message']);
      }
    } catch (e, s) {
      print("Error: ${e}");
      print("Error: ${s}");
      // Get.snackbar('Error', e.toString());
    } finally {
      isGreetingLoading(false); // Set loading state to false
    }
  }


  var greetingFutureCat = <GreetingsCatList>[].obs; // Use Data as per your model
  // var isCatLoading = false.obs; // Observable for loading state
  var isGreetingCatLoading = false.obs;
  Future<void> getGreetingsFutureCategory() async {
    isGreetingCatLoading(true); // Set loading state to true
    try {
      final response = await ApiClient().getGreetingsCategoryClient();
      if (response['status']) {
        // Map the response to BusinessCatModel
        final businessCatModel = GreetingCatResponseModel.fromJson(response);

        // Clear the current list before adding new data
        greetingFutureCat.clear();

        // Add new items to the observable list
        greetingFutureCat.addAll(businessCatModel.data!); // Use addAll here

        print("Business Data:");
        print(greetingFutureCat); // Print the observable list
      } else {
        // Get.snackbar('Error', response['message']);
      }
    } catch (e, s) {
      print("Error: ${e}");
      print("Error: ${s}");
      // Get.snackbar('Error', e.toString());
    } finally {
      isGreetingCatLoading(false); // Set loading state to false
    }
  }

/// for Fetch Today's greetings Category
  var greetingTodayList = <TodayGreetingsCat>[].obs; // Use Data as per your model
  // var isCatLoading = false.obs; // Observable for loading state
  var isGreetingTodayLoading = false.obs;
  Future<void> getGreetingsToday() async {
    isGreetingTodayLoading(true);
    try {
      final response = await ApiClient().getGreetingsTodayCategory();
      if (response['status']) {
        final businessCatModel = TodayGreetingsCatResponse.fromJson(response);

        greetingTodayList.clear();
        greetingTodayList.addAll(businessCatModel.data);

        if (greetingTodayList.isNotEmpty) {
          Get.find<CategoryController>().selectCategory(greetingTodayList.first.name);
          await getGreetingsTodayPost(greetingTodayList.first.greetingSectionId.toString());
        }
      }
    } catch (e, s) {
      print("Error: ${e}");
      print("Error: ${s}");
    } finally {
      isGreetingTodayLoading(false);
    }
  }


/// today's greeting Post by id
  var greetingTodayListPost = <TodayPostGreeting>[].obs;
  var isGreetingTodayPostLoading = false.obs;

  Future<void> getGreetingsTodayPost(String id) async {
    isGreetingTodayPostLoading(true);
    try {
      final response = await ApiClient().getGreetingsTodayCategoryPost(id);
      if (response['status']) {
        // Map the response to BusinessCatModel
        final businessCatModel = TodayGreetingsPostResponse.fromJson(response);

        // Clear the current list before adding new data
        greetingTodayListPost.clear();

        // Add new items to the observable list
        greetingTodayListPost.addAll(businessCatModel.data); // Use addAll here

        print("Today Data:");
        print(greetingTodayListPost); // Print the observable list
      } else {
        // Get.snackbar('Error', response['message']);
      }
    } catch (e, s) {
      print("Error: ${e}");
      print("Error: ${s}");
      // Get.snackbar('Error', e.toString());
    } finally {
      isGreetingTodayPostLoading(false); // Set loading state to false
    }
  }
}
