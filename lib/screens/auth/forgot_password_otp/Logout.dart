import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qr_attendance/screens/auth/controllers/signup_contoller.dart';
import 'package:qr_attendance/screens/auth/welcome.dart';

Future<void> logOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    Get.snackbar("Logout", "Logout Successfully ",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white.withOpacity(0.5),
        colorText: Colors.black);
    SignUpController.instance.resetControllerData();
    Get.to(() => const WelcomeScreen());
    print('User signed out');
  } catch (e) {
    print('Error signing out: $e');
  }
}
