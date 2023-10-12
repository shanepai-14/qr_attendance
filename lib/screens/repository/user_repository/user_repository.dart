import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance/screens/auth/models/attendance_model.dart';
import 'package:qr_attendance/screens/auth/models/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  //Store user in fireStore
  createUser(UserModel user) async {
    await _db
        .collection("Users")
        .add(user.toJson())
        .whenComplete(
          () => Get.snackbar("Success", "Your account has been created",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.1),
              colorText: Colors.green),
        )
        .catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
      print(error.toString());
    });
  }

// Fetch All Users or Userdetails
  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await _db.collection("Users").where("Email", isEqualTo: email).get();
    if (snapshot.docs.isNotEmpty) {
      return UserModel.fromSnapshot(snapshot.docs.first);
    } else {
      throw Exception("No user found with the provided email.");
    }
  }

  Future<AttendanceModel> getUsersAttendanceToday(String email) async {
    DateTime today = DateTime.now();
    DateTime todayWithoutTime = DateTime(today.year, today.month, today.day);
    final snapshot = await _db
        .collection("Attendance")
        .where("Email", isEqualTo: email)
        .where('checkin',
            isGreaterThanOrEqualTo: Timestamp.fromDate(todayWithoutTime))
        .get();
    if (snapshot.docs.isNotEmpty) {
      return AttendanceModel.fromSnapshot(snapshot.docs.first);
    } else {
      throw Exception("No user found with the provided email.");
    }
  }

  Future<List<UserModel>> getAllUserDetails() async {
    final snapshot = await _db.collection("Users").get();
    final userData =
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }

  Future<List<AttendanceModel>> getAllStudentAttendance() async {
    final snapshot = await _db.collection("Attendance").get();
    final attendanceData =
        snapshot.docs.map((e) => AttendanceModel.fromSnapshot(e)).toList();
    return attendanceData;
  }
}
