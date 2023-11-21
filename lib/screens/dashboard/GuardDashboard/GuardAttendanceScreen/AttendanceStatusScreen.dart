import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:Dvciancheck/screens/dashboard/GuardDashboard/GuardAttendanceScreen/EmployeeAttendanceScreen.dart';
import 'package:Dvciancheck/screens/dashboard/GuardDashboard/GuardAttendanceScreen/GuardAttendanceScreen.dart';
import 'package:intl/intl.dart';

class AttendanceStatusScreen extends StatefulWidget {
  const AttendanceStatusScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceStatusScreen> createState() => _AttendanceStatusScreenState();
}

class _AttendanceStatusScreenState extends State<AttendanceStatusScreen> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat.jm().format(now);
    String formattedDate = DateFormat('EEEE, MMMM d').format(now);
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Status'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Text(
                formattedTime,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                formattedDate,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              // Handle on tap for the cards
              Get.to(() => const GuardAttendanceScreen());
            },
            child: Card(
              elevation: 4,
              margin: EdgeInsets.all(25),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Student Attendance",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Todays Attendances',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 15),
                              Text(
                                'Check In : --/-- Check Out : --/--',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Row(
                      children: [
                        Text(
                          'View all ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Icon(Icons.arrow_right, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Handle on tap for the cards
              Get.to(() => const EmployeeAttendanceScreen());
            },
            child: Card(
              elevation: 4,
              margin: EdgeInsets.all(25),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Employee Attendance",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Todays Attendances',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 15),
                              Text(
                                'Check In : --/-- Check Out : --/--',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Row(
                      children: [
                        Text(
                          'View all ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Icon(Icons.arrow_right, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
