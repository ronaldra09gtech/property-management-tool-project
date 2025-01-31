import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquilestate/data/repositories/authentication/authentication_repository.dart';
import 'package:tranquilestate/data/repositories/user/user_model.dart';
import 'package:tranquilestate/data/repositories/user/user_repository.dart';
import 'package:tranquilestate/feature/authentication/screens/signup/verify_email.dart';
import 'package:tranquilestate/utils/constants/image_strings.dart';
import 'package:tranquilestate/utils/helpers/network_manager.dart';
import 'package:tranquilestate/utils/popups/full_screen_loader.dart';
import 'package:tranquilestate/utils/popups/loaders.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  /// Variables
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final email = TextEditingController();
  final lastName = TextEditingController();
  final userName = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  /// Signup
  void signup() async {
    try {

      /// Start Loading
      TFullScreenLoader.openLoadingDialog(
          'We are processing your information...', TImages.docerAnimation);

      /// Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        /// Stop Loading
        TFullScreenLoader.stopLoading();
        return;
      }

      /// Form Validation
      if (!signupFormKey.currentState!.validate()) {
        /// Stop Loading
        TFullScreenLoader.stopLoading();
        return;
      }

      /// Privacy Policy Check
      if (!privacyPolicy.value) {
        TLoaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          message: 'In order to create account, you must have read nd accept the Privacy Policy & Terms of Use.'
        );
        return;
      }

      /// Register user in the Firebase Authentication & Save ser data in the firebase
      final userCredential =  await AuthenticationRepository.instance.registerWithEmailAndPassword(email.text.trim(), password.text.trim());

      /// Save Authenticated user data in the Firebase Firestore
      final newUser = UserModel(
        id: userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        userName: userName.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicture: '',
      );
      final userRepository  = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      /// Stop Loading
      TFullScreenLoader.stopLoading();

      /// Show success messages
      TLoaders.successSnackBar(title: 'Congratulations', message: 'Your Account has been created! verify email to continue.');

      /// Move to verify email screen
      Get.to(() => const VerifyEmailScreen());

    } catch (e) {

      /// Stop Loading
      TFullScreenLoader.stopLoading();

      /// Show some Generic Error to the user
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
