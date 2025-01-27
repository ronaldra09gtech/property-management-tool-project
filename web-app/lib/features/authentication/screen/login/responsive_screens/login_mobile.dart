import 'package:flutter/material.dart';
import 'package:tranquilestate_admin_panel/features/authentication/screen/login/widgets/login_form.dart';
import 'package:tranquilestate_admin_panel/features/authentication/screen/login/widgets/login_header.dart';
import 'package:tranquilestate_admin_panel/utils/constants/sizes.dart';

class LoginScreenMobile extends StatelessWidget {
  const LoginScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              TLoginHeader(),
              TLoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
