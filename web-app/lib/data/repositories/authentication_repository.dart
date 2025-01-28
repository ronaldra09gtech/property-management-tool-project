import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tranquilestate_admin_panel/routes/routes.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //Auth
  final _auth = FirebaseAuth.instance;

  User? get authUser => _auth.currentUser;

  bool get isAuthenticated => _auth.currentUser != null;

  @override
  void onReady() {

    _auth.setPersistence(Persistence.LOCAL);

    // screenRedirect();
  }

  // void screenRedirect() async {
  //   final user = _auth.currentUser;
  //
  //   if (user != null) {
  //     Get.offAllNamed(TRoutes.dashboard);
  //   } else {
  //     Get.offAllNamed(TRoutes.login);
  //   }
  // }
}
