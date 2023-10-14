import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance/screens/auth/models/attendance_model.dart';
import 'package:qr_attendance/screens/repository/authentication_repository/authetication_repository.dart';
import 'package:qr_attendance/screens/repository/user_repository/user_repository.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

  // Step 3- Get User Email and Pass to UserRepository to fetch user record
  getUserData() {
    final email = _authRepo.firebaseUser.value?.email;
    if (email != null) {
      return _userRepo.getUserDetails(email);
    } else {
      Get.snackbar("Error", "Login to Continue");
    }
  }

  Future<List<AttendanceModel>> getAllAttendance() async {
    return await _userRepo.getAllStudentAttendance();
  }

  Future<List<AttendanceModel>> getUserStudentAttendance(String email) async {
    return await _userRepo.getOneUserStudentAttendance(email);
  }

  Future<List<AttendanceModel>> getAllEmployeeAttendance() async {
    return await _userRepo.getAllEmployeeAttendance();
  }

  Future<List<AttendanceModel>> getAttendanceForDate(DateTime date) async {
    final List<AttendanceModel> allAttendance =
        await getAllAttendance(); // Replace with your existing method

    // Filter attendance records for the selected date
    List<AttendanceModel> filteredAttendance = allAttendance
        .where((attendance) =>
            attendance.checkin != null &&
            attendance.checkin?.toDate().year == date.year &&
            attendance.checkin?.toDate().month == date.month &&
            attendance.checkin?.toDate().day == date.day)
        .toList();

    return filteredAttendance;
  }

  Future<List<AttendanceModel>> getUserStudentAttendanceForDateRange(
      DateTimeRange dateRange, String email) async {
    final List<AttendanceModel> UserStudentAttendance =
        await getUserStudentAttendance(email);

    List<AttendanceModel> filteredAttendance =
        UserStudentAttendance.where((attendance) {
      DateTime checkinDate = attendance.checkin?.toDate() ??
          DateTime(
              2023, 10, 13); // Replace with a default date if checkin is null
      return dateRange.start.isBefore(checkinDate) &&
          dateRange.end.isAfter(checkinDate);
    }).toList();

    filteredAttendance.sort((a, b) => b.checkin!.compareTo(a.checkin!));
    return filteredAttendance;
  }

  Future<List<AttendanceModel>> getAttendanceForDateRange(
      DateTimeRange dateRange) async {
    final List<AttendanceModel> allAttendance = await getAllAttendance();

    List<AttendanceModel> filteredAttendance =
        allAttendance.where((attendance) {
      DateTime checkinDate = attendance.checkin?.toDate() ??
          DateTime(
              2023, 10, 13); // Replace with a default date if checkin is null
      return dateRange.start.isBefore(checkinDate) &&
          dateRange.end.isAfter(checkinDate);
    }).toList();

    filteredAttendance.sort((a, b) => b.checkin!.compareTo(a.checkin!));
    return filteredAttendance;
  }

  Future<List<AttendanceModel>> getAttendanceEmployeeForDateRange(
      DateTimeRange dateRange) async {
    final List<AttendanceModel> allEmployeeAttendance =
        await getAllEmployeeAttendance();

    List<AttendanceModel> filteredAttendance =
        allEmployeeAttendance.where((attendance) {
      DateTime checkinDate = attendance.checkin?.toDate() ??
          DateTime(
              2023, 10, 13); // Replace with a default date if checkin is null
      return dateRange.start.isBefore(checkinDate) &&
          dateRange.end.isAfter(checkinDate);
    }).toList();

    filteredAttendance.sort((a, b) => b.checkin!.compareTo(a.checkin!));
    return filteredAttendance;
  }

  // Future<List<AttendanceModel>> getAttendanceForDateRange(
  //   DateTimeRange? dateRange,
  // ) async {
  //   final List<AttendanceModel> allAttendance = await getAllAttendance();
  //
  //   List<AttendanceModel> filteredAttendance = [];
  //
  //   if (dateRange != null) {
  //     filteredAttendance = allAttendance.where((attendance) {
  //       DateTime checkinDate = attendance.checkin?.toDate() ??
  //           DateTime(
  //               2023, 10, 13); // Replace with a default date if checkin is null
  //       return dateRange.start.isBefore(checkinDate) &&
  //           dateRange.end.isAfter(checkinDate);
  //     }).toList();
  //
  //     filteredAttendance.sort((a, b) => b.checkin!.compareTo(a.checkin!));
  //   } else {
  //     // If dateRange is null, add today's date to the list
  //     DateTime today = DateTime.now();
  //     filteredAttendance = allAttendance.where((attendance) {
  //       DateTime checkinDate = attendance.checkin?.toDate() ??
  //           DateTime.now(); // Replace with a default date if checkin is null
  //       return today.isAtSameMomentAs(checkinDate);
  //     }).toList();
  //
  //     filteredAttendance.sort((a, b) => b.checkin!.compareTo(a.checkin!));
  //   }
  //
  //   return filteredAttendance;
  // }
}
