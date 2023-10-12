import 'package:get/get.dart';
import 'package:qr_attendance/screens/auth/models/attendance_model.dart';
import 'package:qr_attendance/screens/auth/models/user_model.dart';
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
}
