import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tranquilestate_admin_panel/data/repositories/authentication_repository.dart';
import 'package:tranquilestate_admin_panel/data/repositories/user_repository.dart';
import 'package:tranquilestate_admin_panel/features/authentication/controller/user_controller.dart';
import 'package:tranquilestate_admin_panel/features/authentication/model/user_model.dart';
import 'package:tranquilestate_admin_panel/utils/constants/enums.dart';
import 'package:tranquilestate_admin_panel/utils/constants/image_strings.dart';
import 'package:tranquilestate_admin_panel/utils/constants/text_strings.dart';
import 'package:tranquilestate_admin_panel/utils/helpers/network_manager.dart';
import 'package:tranquilestate_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:tranquilestate_admin_panel/utils/popups/loaders.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final hidePassword = true.obs;
  final rememberMe = false.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    super.onInit();
  }

  /// Handles email and password sign-in process
  Future<void> emailAndPasswordSignIn() async {
    try {
      /// Start Loading
      TFullScreenLoader.openLoadingDialog(
          'Registering Admin Account...', TImages.docerAnimation);

      /// Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      /// Form Validation
      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      /// Save Data if Remember Me is selected
      if (rememberMe.value) {
        localStorage.write('REMEBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      /// Login user using Email & Password Authentication
      await AuthenticationRepository.instance.loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      /// Fetch user details and assign to UserController
      final user = await UserController.instance.fetchUserDetails();

      /// Remove Loader
      TFullScreenLoader.stopLoading();

      /// If user is not admin, logout and return
      if (user.role != AppRole.admin){
        await AuthenticationRepository.instance.logout();
        TLoaders.errorSnackBar(title: 'Not Authorized', message: 'You are not authorized or do have access. Contact Admin');
      } else {
        /// Redirect
        AuthenticationRepository.instance.screenRedirect();
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  /// Handles registration of admin user
  Future<void> registerAdmin() async {
    try {
      /// Start Loading
      TFullScreenLoader.openLoadingDialog(
          'Registering Admin Account...', TImages.docerAnimation);

      /// Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      /// Register user using Email & Password Authentication
      await AuthenticationRepository.instance.registerWithEmailAndPassword(
          TTexts.adminEmail, TTexts.adminPassword);

      /// Create admin record in the Firestore
      final userRepository = Get.put(UserRepository());
      await userRepository.createUser(UserModel(
        id: AuthenticationRepository.instance.authUser!.uid,
        firstName: 'Ronald',
        lastName: 'Avila',
        email: TTexts.adminEmail,
        role: AppRole.admin,
        createdAt: DateTime.now(),
      ));
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
