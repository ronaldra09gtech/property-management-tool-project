import 'package:flutter/material.dart';
import 'package:tranquilestate_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:tranquilestate_admin_panel/features/authentication/screen/reset_password/responsive_screen/reset_password_desktop_tablet.dart';
import 'package:tranquilestate_admin_panel/features/authentication/screen/reset_password/responsive_screen/reset_password_mobile.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  // ignore: annotate_overrides
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      useLayout: false,
      desktop: ResetPasswordScreenDesktopTablet(),
      mobile: ResetPasswordScreenMobile(),
    );
  }
}
