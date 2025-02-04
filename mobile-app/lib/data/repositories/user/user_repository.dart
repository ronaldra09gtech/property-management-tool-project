import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tranquilestate/data/repositories/user/user_model.dart';
import 'package:tranquilestate/utils/exceptions/firebase_exceptions.dart';
import 'package:tranquilestate/utils/exceptions/format_exceptions.dart';
import 'package:tranquilestate/utils/exceptions/platform_exceptions.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  ///Function to save user data to firestore.

  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).set(user.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw '問題が発生しました。もう一度試してください';
    }
  }
}
