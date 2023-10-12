import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  final Timestamp? checkin;
  final Timestamp? checkout;
  final String? id;
  final String fullName;
  final String email;
  final String course;
  final String phoneNo;
  final String year;
  final String usertype;

  const AttendanceModel(
      {this.id,
      this.checkin,
      this.checkout,
      required this.usertype,
      required this.email,
      required this.fullName,
      required this.course,
      required this.phoneNo,
      required this.year});

  toJson() {
    return {
      "Fullname": fullName,
      "Email": email,
      "Phone": phoneNo,
      "Course": course,
      "Year": year,
      'usertype': usertype,
      'checkin': getCurrentTime(),
      'checkout': getCurrentTime(),
    };
  }

  getCurrentTime() {
    DateTime now = DateTime.now();
    Timestamp timestamp = Timestamp.fromDate(now);

    return timestamp;
  }

  factory AttendanceModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return AttendanceModel(
      id: document.id,
      email: data["Email"],
      fullName: data["Fullname"],
      course: data["Course"],
      phoneNo: data["Phone"],
      year: data["Year"],
      checkin: data["checkin"],
      checkout: data["checkout"],
      usertype: data["usertype"],
    );
  }
}
