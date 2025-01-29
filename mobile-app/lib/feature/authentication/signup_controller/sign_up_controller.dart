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

  ///VARIABLES
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final email = TextEditingController();
  final lastName = TextEditingController();
  final userName = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  ///SIGNUP
  void signup() async {
    try {

      ///START LOADING
      TFullScreenLoader.openLoadingDialog(
          'We are processing your information...', TImages.productImage1);


      ///CHECK INTERNET CONNECTIVITY
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;


      ///FROM VALIDATION
      if (!signupFormKey.currentState!.validate()) return;

      //PRIVACY POLICY CHECK
      if (!privacyPolicy.value) {
        TLoaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          message: 'In order to create account, you must have read nd accept the Privacy Policy & Terms of Use.'
        );
        return;
      }

      //register user in the firebase authentication & save data in the user data in the firebase
      final userCredential =  await AuthenticationRepository.instance.registerWithEmailAndPassword(email.text.trim(), password.text.trim());

      //save authenticated user data in the firebase firestore
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

      //show success messages
      TLoaders.successSnackBar(title: 'Congratulations', message: 'Your Account has been created! verify email to continue.');
      //move to verify email screen
      Get.to(() => VerifyEmailScreen(email: email.text.trim(),));
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      TFullScreenLoader.stopLoading();
    }
  }
}
