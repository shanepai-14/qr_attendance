import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final Timestamp? timestamp;
  final String? usertype;
  final String? id;
  final String fullName;
  final String email;
  final String course;
  final String phoneNo;
  final String year;
  final String password;

  const UserModel(
      {this.id,
      this.timestamp,
      this.usertype,
      required this.email,
      required this.password,
      required this.fullName,
      required this.course,
      required this.phoneNo,
      required this.year});

  toJson() {
    return {
      "Fullname": fullName,
      "Email": email,
      "Phone": phoneNo,
      "Password": password,
      "Course": course,
      "Year": year,
      'usertype': 'Student',
      'timestamp': getCurrentTime()
    };
  }

  getCurrentTime() {
    DateTime now = DateTime.now();
    Timestamp timestamp = Timestamp.fromDate(now);

    return timestamp;
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        id: document.id,
        email: data["Email"],
        password: data["Password"],
        fullName: data["Fullname"],
        course: data["Course"],
        phoneNo: data["Phone"],
        year: data["Year"],
        usertype: data["usertype"],
        timestamp: data["timestamp"]);
  }
}
