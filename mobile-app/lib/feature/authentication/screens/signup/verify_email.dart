import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquilestate/common/widgets/success_screen/success_screen.dart';
import 'package:tranquilestate/data/repositories/authentication/authentication_repository.dart';
import 'package:tranquilestate/feature/authentication/screens/login/login.dart';
import 'package:tranquilestate/utils/constants/image_strings.dart';
import 'package:tranquilestate/utils/constants/sizes.dart';
import 'package:tranquilestate/utils/constants/text_strings.dart';
import 'package:tranquilestate/utils/helpers/helper_functions.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(const VerifyEmailScreen());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => AuthenticationRepository.instance.logout(),
              icon: const Icon(CupertinoIcons.clear)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              Image(
                image: AssetImage(TImages.deliveredEmailIllustration),
                width: THelperFunctions.screenWidth() * 0.6,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              Text(TTexts.confirmEmail,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwSections),
              Text(email ?? '',
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwSections),
              Text(TTexts.confirmEmailSubTitle,
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => Get.to(() => SuccessScreen(
                          image: TImages.staticSuccessIllustration,
                          title: TTexts.yourAccountCreatedTitle,
                          subTitle: TTexts.yourAccountCreatedSubTitle,
                          onPressed: () => Get.to(() => const LoginScreen()),
                        )),
                    child: const Text(TTexts.tContinue)),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {}, child: const Text(TTexts.resendEmail)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
