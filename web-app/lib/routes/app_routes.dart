import 'package:get/get.dart';
import 'package:tranquilestate_admin_panel/app.dart';
import 'package:tranquilestate_admin_panel/routes/routes.dart';
import 'package:tranquilestate_admin_panel/routes/routes_middleware.dart';

class TAppRoute {
  static final List<GetPage> pages = [
    GetPage(
        name: TRoutes.login,
        page: () => const ResponsiveDesignScreen(),
        middlewares: [TRouteMiddleare()]),
    // GetPage(name: TRoutes.forgotPassword, page: () => const ForgotPasswordScreen()),
    // GetPage(name: TRoutes.resetPassword, page: () => const ResetPasswordScreen()),
    // GetPage(name: TRoutes.dashboard, page: () => const DashboardScreen()),
  ];
}
