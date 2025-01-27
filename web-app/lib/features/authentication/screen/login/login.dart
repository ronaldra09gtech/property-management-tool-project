import 'package:flutter/material.dart';
import 'package:tranquilestate_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:tranquilestate_admin_panel/features/authentication/screen/login/responsive_screens/login_desktop_tablet.dart';
import 'package:tranquilestate_admin_panel/features/authentication/screen/login/responsive_screens/login_mobile.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      useLayout: false,
      desktop: LoginScreenDesktopTablet(),
      mobile: LoginScreenMobile(),
    );
  }
}
