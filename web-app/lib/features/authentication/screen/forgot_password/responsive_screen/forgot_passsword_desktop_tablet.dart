import 'package:flutter/material.dart';
import 'package:tranquilestate_admin_panel/common/widgets/layouts/templates/login_template.dart';
import 'package:tranquilestate_admin_panel/features/authentication/screen/forgot_password/widgets/header_form.dart';

class ForgotPassswordScreenDesktopTablet extends StatelessWidget {
  const ForgotPassswordScreenDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return TLoginTemplate(
      child: HeaderandForm(),
    );
  }
}
