import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tranquilestate/data/repositories/user/user_repository.dart';
import 'package:tranquilestate/feature/perosanilzation/controller/user_controller.dart';
import 'package:tranquilestate/feature/perosanilzation/screens/profile/widgets/profile.dart';
import 'package:tranquilestate/utils/constants/image_strings.dart';
import 'package:tranquilestate/utils/helpers/network_manager.dart';
import 'package:tranquilestate/utils/popups/full_screen_loader.dart';
import 'package:tranquilestate/utils/popups/loaders.dart';

class UpdateNameController extends GetxController {
  static UpdateNameController get instance => Get.find();

  /// Variables
  final firstName = TextEditingController();
  final lastname = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateUserNameFormKey = GlobalKey<FormState>();

  /// Init user data when Home Screen appears
  @override
  void onInit() {
    initializedNames();
    super.onInit();
  }

  Future<void> initializedNames() async {
    firstName.text = userController.user.value.firstName;
    lastname.text = userController.user.value.lastName;
  }

  Future<void> updateUserName() async {
    try {
      /// Start Loading
      TFullScreenLoader.openLoadingDialog('We are updating your information...', TImages.docerAnimation);

      /// Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      /// Form Validation
      if (!updateUserNameFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      /// Update user's first & last name in the Firebase Firestore
      Map<String, dynamic> name = {'FirstName': firstName.text.trim(), 'LastName': lastname.text.trim()};
      await userRepository.updateSingleField(name);

      /// Update the Rx User value
      userController.user.value.firstName = firstName.text.trim();
      userController.user.value.lastName = lastname.text.trim();

      /// Remove Loader
      TFullScreenLoader.stopLoading();

      /// Show Success Message
      TLoaders.successSnackBar(title: 'Congratulations', message: 'Your Name has been updated.');

      /// Move to previous screen
      Get.off(() => const ProfileScreen());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}