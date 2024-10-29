import 'package:get/get.dart';

class CategoryController extends GetxController {
  var selectedCategory = 'Ganesh chaturthi'.obs;
  var moreCategoriesVisible = false.obs;

  void selectCategory(String category) {
    selectedCategory.value = category;
  }
  void resetCategory() {
    selectedCategory.value = '';  // Reset to no category selected
  }
  void toggleMoreCategories() {
    moreCategoriesVisible.value = !moreCategoriesVisible.value;
  }
}
