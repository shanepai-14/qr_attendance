import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart'; // Import your UserModel

class UserController extends GetxController {
  var user = UserModel(
    email: '',
    password: '',
    fullName: '',
    course: '',
    phoneNo: '',
    year: '',
    usertype: '',
    timestamp: null,
  ).obs;

  Future<void> saveUserData(UserModel userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', userData.email!);
    await prefs.setString('password', userData.password!);
    await prefs.setString('fullName', userData.fullName!);
    await prefs.setString('course', userData.course!);
    await prefs.setString('phoneNo', userData.phoneNo!);
    await prefs.setString('year', userData.year!);
    await prefs.setString('usertype', userData.usertype!);
    print(userData.toJson());
    user.value = userData;
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    final fullName = prefs.getString('fullName');
    final course = prefs.getString('course');
    final phoneNo = prefs.getString('phoneNo');
    final year = prefs.getString('year');
    final usertype = prefs.getString('usertype');
    final timestamp = prefs.getString('timestamp');

    UserModel user = UserModel(
      email: email,
      password: password,
      fullName: fullName,
      course: course,
      phoneNo: phoneNo,
      year: year,
      usertype: usertype, // Provide a value for usertype if necessary
      timestamp: null, // Provide a value for timestamp if necessary
    );
  }
}
