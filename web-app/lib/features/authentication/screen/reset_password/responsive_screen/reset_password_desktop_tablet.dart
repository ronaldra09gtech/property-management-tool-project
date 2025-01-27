import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquilestate_admin_panel/common/widgets/layouts/templates/login_template.dart';
import 'package:tranquilestate_admin_panel/features/authentication/screen/reset_password/widgets/reset_password_widget.dart';

class ResetPasswordScreenDesktopTablet extends StatelessWidget {
  const ResetPasswordScreenDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    final email = Get.parameters['email'] ?? '';

    return TLoginTemplate(
      child: ResetPasswordWidget(email: email),
    );
  }
}
