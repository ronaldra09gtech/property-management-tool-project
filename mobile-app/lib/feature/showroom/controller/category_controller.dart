import 'package:get/get.dart';
import 'package:tranquilestate/data/repositories/categories/category_repository.dart';
import 'package:tranquilestate/feature/showroom/models/category_model.dart';
import 'package:tranquilestate/utils/popups/loaders.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  /// Variable
  final isLoading = false.obs;
  final _categoryRepository = Get.put(CategoryRepository());
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  /// Load Category Data
  Future<void> fetchCategories() async {
    try {
      /// Show loader whie loading categories
      isLoading.value = true;

      /// Fetch categories from data source (Firestore, API, etc.)
      final categories = await _categoryRepository.getAllCategories();

      /// Update the categories list
      allCategories.assignAll(categories);

      /// Filter featured categories
      featuredCategories.assignAll(allCategories.where((category) => category.isFeatured && category.parentId.isEmpty));
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      /// Remove Loader
      isLoading.value = false;
    }
  }
}
