import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquilestate/common/styles/spacing_styles.dart';
import 'package:tranquilestate/common/widgets/login_signup/form_divider.dart';
import 'package:tranquilestate/common/widgets/login_signup/social_buttons.dart';
import 'package:tranquilestate/feature/authentication/screens/login/widgets/login_form.dart';
import 'package:tranquilestate/feature/authentication/screens/login/widgets/login_header.dart';
import 'package:tranquilestate/utils/constants/sizes.dart';
import 'package:tranquilestate/utils/constants/text_strings.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              const TLoginHeader(),
              const TLoginForm(),
              TFormDivider(dividerText: TTexts.orSignInWith.capitalize!),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              const TSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
