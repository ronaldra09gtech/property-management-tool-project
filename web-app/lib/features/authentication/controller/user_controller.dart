import 'package:get/get.dart';
import 'package:tranquilestate_admin_panel/data/repositories/user_repository.dart';
import 'package:tranquilestate_admin_panel/features/authentication/model/user_model.dart';
import 'package:tranquilestate_admin_panel/utils/popups/loaders.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final userRepository = Get.put(UserRepository());

  Future<UserModel> fetchUserDetails() async {
    try {
      final user = await userRepository.fetchAdminDetails();
      return user;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Something went wrong.', message: e.toString());
      return UserModel.empty();
    }
  }
}