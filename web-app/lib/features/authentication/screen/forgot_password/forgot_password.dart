import 'package:flutter/material.dart';
import 'package:tranquilestate_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:tranquilestate_admin_panel/features/authentication/screen/forgot_password/responsive_screen/forgot_passsword_desktop_tablet.dart';
import 'package:tranquilestate_admin_panel/features/authentication/screen/forgot_password/responsive_screen/forgot_password_mobile.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  Widget build(BuildContext context) {
    return const TSiteTemplate(
      useLayout: false,
      desktop: ForgotPassswordScreenDesktopTablet(),
      mobile: ForgotPasswordScreenMobile(),
    );
  }
}
