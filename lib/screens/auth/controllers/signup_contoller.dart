import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Dvciancheck/screens/repository/authentication_repository/authetication_repository.dart';
import '../models/user_model.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final fullname = TextEditingController();
  final phone = TextEditingController();
  final course = TextEditingController();
  final year = TextEditingController();

  // Future<void> registerUser(String email, String password) async {
  //   await AuthenticationRepository.instance
  //       .createUserWithEmailAndPassword(email, password);
  // }

  Future<void> LoginUser(String email, String password) async {
    //await Get.find<UserController>().saveUserData(userData);
    await AuthenticationRepository.instance
        .LoginUserWithEmailAndPassword(email, password);
  }

  Future<void> createUser(UserModel user, String email, String password) async {
    try {
      await AuthenticationRepository.instance
          .createUserWithEmailAndPassword(email, password, user);
    } on Exception catch (e) {
      Get.snackbar("Email", "Already exist" + e.toString(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green);
    }
  }

  void resetControllerData() {
    email.clear();
    password.clear();
    fullname.clear();
    phone.clear();
    course.clear();
    year.clear();
  }
}
