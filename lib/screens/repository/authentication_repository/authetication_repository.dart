import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fk_toggle/fk_toggle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance/screens/auth/login.dart';
import 'package:qr_attendance/screens/auth/welcome.dart';
import 'package:qr_attendance/screens/dashboard/GuardDashboard/GuardDashboard.dart';
import 'package:qr_attendance/screens/dashboard/dashboard.dart';
import 'package:qr_attendance/screens/repository/authentication_repository/exceptions/signup_email_password_failure.dart';
import 'package:intl/intl.dart';
import 'package:qr_attendance/screens/repository/authentication_repository/smsapi.dart';
import '../../auth/controllers/user_controller.dart';
import '../../auth/models/user_model.dart';
import '../user_repository/user_repository.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  // _setInitialScreen(User? user) {
  //   user == null
  //       ? Get.off(() => const WelcomeScreen())
  //       : Get.off(() => const Dashboard());
  // }

  // Future<void> createUserWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     await _auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     firebaseUser.value != null
  //         ? Get.offAll(() => const Dashboard())
  //         : Get.to(() => const WelcomeScreen());
  //   } on FirebaseAuthException catch (e) {
  //     // TODO
  //     final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
  //     print('FIREBASE AUTH EXCEPTION -${ex.message}');
  //     throw ex;
  //   } catch (_) {
  //     const ex = SignUpWithEmailAndPasswordFailure();
  //     print('EXCEPTION - ${ex.message}');
  //     throw ex;
  //   }
  // }

  // void _setInitialScreen(User? user) async {
  //   if (user == null) {
  //     Get.off(() => const WelcomeScreen());
  //   } else {
  //     DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //         .collection('Users')
  //         .doc(user.uid)
  //         .get();
  //
  //     String? userType = userDoc.get('usertype');
  //
  //     if (userType == 'Student') {
  //       Get.off(() => const Dashboard());
  //     } else {
  //       Get.off(() => const GuardDashboardScreen());
  //     }
  //   }
  // }
  final UserController userController = Get.find<UserController>();
  final userRepo = Get.put(UserRepository());
  // void _setInitialScreen(User? user) async {
  //   if (user == null) {
  //     Get.off(() => const WelcomeScreen());
  //   } else {
  //     String email = user.email!;
  //     UserModel userData = await userRepo.getUserDetails(email);
  //     String? usertype = userController.user.value.usertype;
  //     if (usertype == 'Student') {
  //       Get.off(() => const Dashboard());
  //       print("user dashboard $usertype");
  //     } else {
  //       Get.off(() => const GuardDashboardScreen());
  //       print("user admindashboard $usertype");
  //     }
  //   }
  // }
  void _setInitialScreen(User? user) async {
    if (user == null) {
      Get.off(() => const WelcomeScreen());
    } else {
      String email = user.email!;
      UserModel userData = await userRepo.getUserDetails(email);
      userController.user.value =
          userData; // Set the user data in the controller
      String? usertype =
          userData.usertype; // Access usertype from the fetched data

      if (usertype == 'Student' || usertype == 'Employee') {
        Get.off(() => const Dashboard());
        print("user dashboard $usertype");
      } else {
        Get.off(() => const GuardDashboardScreen());
        print("user admindashboard $usertype");
      }
    }
  }

  Future<void> fetchAndUploadAttendance(String email, bool checkin) async {
    try {
      // Step 1: Fetch user data based on email
      UserModel userData = await userRepo.getUserDetails(email);

      // Step 2: Upload to Attendance collection
      await uploadToAttendanceCollection(userData, checkin);
    } catch (e) {
      Get.snackbar("ERROR", "PLEASE CHECK YOUR INTERNET ",
          duration: Duration(seconds: 1),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade200,
          colorText: Colors.white);
      print('Error: $e');
    }
  }

  //old function for scanner
  // Future<void> uploadToAttendanceCollection(UserModel userData) async {
  //   try {
  //     Map<String, dynamic> data = {
  //       'Course': userData.course,
  //       'Email': userData.email,
  //       'Entry': 'checkin',
  //       'Fullname': userData.fullName,
  //       'Year': userData.year,
  //       'Phone': userData.phoneNo,
  //       'timestamp': Timestamp.now(),
  //     };
  //
  //     await FirebaseFirestore.instance.collection('Attendance').add(data);
  //     Get.snackbar("Success", "Scanned : " + userData.fullName,
  //         snackPosition: SnackPosition.TOP,
  //         backgroundColor: Colors.green.shade200,
  //         colorText: Colors.white);
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }
  static const String apiKey = 'JFDnkvoaZLt-nwcCDboEV8v8V3zh6X';
  static const String apiSecret = 'CcTY03NAMlj2GWwGpJLLJkbZ1msY1K';
  // static const String senderId = 'YOUR_SENDER_ID';
  static const String apiUrl = 'https://api.movider.co/v1/sms';

  Future<void> sendSms(String phoneNumber, String message) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $apiKey:$apiSecret',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'to': phoneNumber,
        'message': message,
      }),
    );

    if (response.statusCode == 200) {
      print('SMS sent successfully');
    } else {
      print('Failed to send SMS. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> uploadToAttendanceCollection(
      UserModel userData, bool checkin) async {
    try {
      DateTime today = DateTime.now();
      DateTime dateTime = DateTime(1999, 8, 30, 12, 34);
      Timestamp timestamp = Timestamp.fromDate(dateTime);
      // Remove the time component from today's DateTime
      DateTime todayWithoutTime = DateTime(today.year, today.month, today.day);

      // QuerySnapshot duplicateCheck = await FirebaseFirestore.instance
      //     .collection('Attendance')
      //     .where('Email', isEqualTo: userData.email)
      //     .where('timestamp',.where('Entry', isEqualTo: 'checkin')
      //         isGreaterThanOrEqualTo: Timestamp.fromDate(todayWithoutTime))
      //     .get();

      QuerySnapshot duplicateCheck = await FirebaseFirestore.instance
          .collection('Attendance')
          .where('Email', isEqualTo: userData.email)
          .where('checkin',
              isGreaterThanOrEqualTo: Timestamp.fromDate(todayWithoutTime))
          .get();

      // QuerySnapshot checkout = await FirebaseFirestore.instance
      //     .collection('Attendance')
      //     .where('Email', isEqualTo: userData.email)
      //     .where('Entry', isEqualTo: 'checkout')
      //     .where('timestamp',
      //         isGreaterThanOrEqualTo: Timestamp.fromDate(todayWithoutTime))
      //     .get();

      if (duplicateCheck.docs.isEmpty && checkin == true) {
        Map<String, dynamic> data = {
          'Course': userData.course,
          'Email': userData.email,
          'Fullname': userData.fullName,
          'Year': userData.year,
          'Phone': userData.phoneNo,
          'checkin': Timestamp.now(),
          'checkout': timestamp,
          'usertype': userData.usertype
        };
        String fullName = userData.fullName ?? '';
        await FirebaseFirestore.instance.collection('Attendance').add(data);
        Get.snackbar("Successfully", "Check In :" + fullName,
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green.shade200,
            colorText: Colors.white);
      } else if (checkin == false &&
          duplicateCheck.docs.first.get('checkin') != null &&
          duplicateCheck.docs[0]['checkout'] == timestamp) {
        String documentID = duplicateCheck.docs[0].id;
        if (duplicateCheck.docs[0]['checkout'] == timestamp) {
          // Update the 'checkout' field
          await FirebaseFirestore.instance
              .collection('Attendance')
              .doc(documentID)
              .update({'checkout': Timestamp.now()});
        }
        String fullName = userData.fullName ?? '';
        sendSms('09913731732', 'User Login');
        Get.snackbar(
            "Successfully", "Check out for today's attendance : " + fullName,
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 2),
            backgroundColor: Colors.blue.shade200,
            colorText: Colors.white);
      } else if (checkin == true &&
          duplicateCheck.docs.isNotEmpty &&
          duplicateCheck.docs[0]['checkout'] == timestamp) {
        Get.snackbar("ERROR", "User has already checked in.",
            duration: Duration(seconds: 1),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.shade200,
            colorText: Colors.white);
      } else if (duplicateCheck.docs.isNotEmpty &&
          duplicateCheck.docs[0]['checkin'] != null &&
          duplicateCheck.docs[0]['checkout'] != null) {
        Get.snackbar("ERROR",
            "User has already checked in and check out for attendance.",
            duration: Duration(seconds: 1),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.shade200,
            colorText: Colors.white);
      } else if (duplicateCheck.docs.isEmpty && checkin == false) {
        Get.snackbar("ERROR", "Please check in before checking out.",
            duration: Duration(seconds: 1),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.shade200,
            colorText: Colors.white);
      } else {
        Get.snackbar("ERROR", "Something went wrong",
            duration: Duration(seconds: 1),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.shade200,
            colorText: Colors.white);
      }

      // if (entry == 'checkout' &&
      //     duplicateCheck.docs.first.get('Entry') == 'checkin') {
      //   Map<String, dynamic> data = {
      //     'Course': userData.course,
      //     'Email': userData.email,
      //     'Entry': entry,
      //     'Fullname': userData.fullName,
      //     'Year': userData.year,
      //     'Phone': userData.phoneNo,
      //     'timestamp': Timestamp.now(),
      //   };
      //
      //   await FirebaseFirestore.instance.collection('Attendance').add(data);
      //
      //   Get.snackbar("Succesfully", "Check Out :" + userData.fullName,
      //       snackPosition: SnackPosition.TOP,
      //       backgroundColor: Colors.blueAccent.shade200,
      //       colorText: Colors.white);
      // }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("ERROR", 'Please check in before checking out.',
          duration: Duration(seconds: 1),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade200,
          colorText: Colors.white);
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password, UserModel user) async {
    try {
      // Check if the email is already in use
      List<String> signInMethods =
          await _auth.fetchSignInMethodsForEmail(email);

      if (signInMethods.isNotEmpty) {
        // Email is already in use

        throw SignUpWithEmailAndPasswordFailure.code('email-already-in-use');
      }

      // If email is not in use, create a new account
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await userRepo.createUser(user);
      // Handle successful registration
      firebaseUser.value != null
          ? Get.offAll(() => const Dashboard())
          : Get.to(() => const WelcomeScreen());
    } on FirebaseAuthException catch (e) {
      // Handle specific exceptions
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    } catch (_) {
      // Handle other exceptions
      const ex = SignUpWithEmailAndPasswordFailure();
      print('EXCEPTION - ${ex.message}');
      throw ex;
    }
  }

  // Future<void> LoginUserWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     await _auth.signInWithEmailAndPassword(email: email, password: password);
  //     Get.snackbar("Login", "Successfully",
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.white,
  //         colorText: Colors.black);
  //   } on FirebaseAuthException catch (e) {
  //     Get.snackbar("Wrong Credentials", "Check your email or password ",
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.white,
  //         colorText: Colors.black);
  //   } catch (_) {}
  // }

  Future<void> LoginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        String? userType = userDoc.get('usertype');

        UserModel userData = UserModel.fromSnapshot(
            userDoc as DocumentSnapshot<Map<String, dynamic>>);

        UserController userController = Get.find<UserController>();
        await userController.saveUserData(userData);

        if (userType != null && userType.isNotEmpty) {
          if (userType == 'Student') {
            Get.off(() => const Dashboard());
          } else {
            Get.off(() => const GuardDashboardScreen());
          }
        }
      }

      Get.snackbar("Login", "Successfully",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white,
          colorText: Colors.black);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Wrong Credentials", "Check your email or password ",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white,
          colorText: Colors.black);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> logout() async => await _auth.signOut();
}
