import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tranquilestate/common/widgets/success_screen/success_screen.dart';
import 'package:tranquilestate/data/repositories/authentication/authentication_repository.dart';
import 'package:tranquilestate/utils/constants/image_strings.dart';
import 'package:tranquilestate/utils/constants/text_strings.dart';
import 'package:tranquilestate/utils/popups/loaders.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  @override
  void onInit() {
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }
  /// Send Email Verification Link
  sendEmailVerification() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      TLoaders.successSnackBar(title: 'メール送信済み', message: '受信箱をチェックしてメールを確認してください。');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  /// Timer to automatically redirect on email verification

  setTimerForAutoRedirect() {
    Timer.periodic(
      const Duration(seconds: 2),
        (timer) async {
        await FirebaseAuth.instance.currentUser?.reload();
        final user = FirebaseAuth.instance.currentUser;
        if(user?.emailVerified ?? false){
          timer.cancel();
          Get.off(()=> SuccessScreen(
              image: TImages.successfulPaymentIcon,
              title: TTexts.yourAccountCreatedTitle,
              subTitle: TTexts.yourAccountCreatedSubTitle,
              onPressed: () => AuthenticationRepository.instance.screenRedirect()
            )
          );
        }
      }
    );
  }

  ///Manually Check if Email Verified
  checkEmailVerificationStatus() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Get.off(() => SuccessScreen(
          image: TImages.successfulPaymentIcon,
          title: TTexts.yourAccountCreatedTitle,
          subTitle: TTexts.yourAccountCreatedSubTitle,
          onPressed: () => AuthenticationRepository.instance.screenRedirect()
        ),
      );
    }
  }
}
