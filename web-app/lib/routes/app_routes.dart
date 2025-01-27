import 'package:get/get.dart';
import 'package:tranquilestate_admin_panel/features/authentication/screen/forgot_password/forgot_password.dart';
import 'package:tranquilestate_admin_panel/features/authentication/screen/login/login.dart';
import 'package:tranquilestate_admin_panel/features/authentication/screen/reset_password/reset_password.dart';
import 'package:tranquilestate_admin_panel/routes/routes.dart';

class TAppRoute {
  static final List<GetPage> pages = [
    GetPage(name: TRoutes.login, page: () => const LoginScreen()),
    GetPage(name: TRoutes.forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(name: TRoutes.resetPassword, page: () => const ResetPasswordScreen()),
    // GetPage(name: TRoutes.dashboard, page: () => const DashboardScreen()),
  ];
}
