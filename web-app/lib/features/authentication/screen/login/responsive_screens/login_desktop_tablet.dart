import 'package:flutter/material.dart';
import 'package:tranquilestate_admin_panel/common/widgets/layouts/templates/login_template.dart';
import 'package:tranquilestate_admin_panel/features/authentication/screen/login/widgets/login_form.dart';
import 'package:tranquilestate_admin_panel/features/authentication/screen/login/widgets/login_header.dart';

class LoginScreenDesktopTablet extends StatelessWidget {
  const LoginScreenDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return const TLoginTemplate(
      child: Column(
        children: [
          TLoginHeader(),
          TLoginForm(),
        ],
      ),
    );
  }
}
