import 'package:flutter/material.dart';
import 'package:tranquilestate_admin_panel/features/authentication/screen/forgot_password/widgets/header_form.dart';
import 'package:tranquilestate_admin_panel/utils/constants/sizes.dart';

class ForgotPasswordScreenMobile extends StatelessWidget {
  const ForgotPasswordScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(TSizes.defaultSpace),
          child: HeaderandForm(),
        ),
      ),
    );
  }
}
