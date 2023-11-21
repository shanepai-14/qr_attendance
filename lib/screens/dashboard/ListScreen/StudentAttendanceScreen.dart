import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:Dvciancheck/screens/auth/models/attendance_model.dart';
import 'package:Dvciancheck/screens/dashboard/ProfileScreen/ProfileScreen.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:android_path_provider/android_path_provider.dart';

import '../../auth/controllers/user_controller.dart';

class StudentAttendanceScreen extends StatefulWidget {
  const StudentAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<StudentAttendanceScreen> createState() =>
      _StudentAttendanceScreenState();
}

DateTime selectedDate = DateTime.now();
final UserController userController = Get.find<UserController>();

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  final List<String> courseCategories = ['BSIT', 'BSED', 'BEED', 'THEO'];
  final List<String> yearCategories = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year'
  ];
  String searchQuery = '';
  Set<String> selectedCourses = Set<String>();
  Set<String> selectedYears = Set<String>();
  // Initialize with current date
  DateTimeRange selectedDateRange = DateTimeRange(
    start: DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
    end: DateTime.now().add(Duration(days: 1)),
  );
  List<AttendanceModel> filteredAttendance = [];
  Future<void> _exportData() async {
    // Show a dialog for confirmation
    bool confirmExport = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Export Data'),
          content: Text('Are you sure you want to export the data?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmed export
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel export
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );

    if (confirmExport == true) {
      // User confirmed export, proceed with exporting data
      // Implement your export logic here

      exportData(filteredAttendance);
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: selectedDateRange,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> exportData(List<AttendanceModel> data) async {
    // Create a list of rows for the Excel file
    List<List<String>> rows = [];

    // Add headers to the rows
    if (userController.user.value.usertype.toString() == "Student") {
      rows.add(
          ['Full Name', 'Course', 'Year', 'Checkin Date', 'Checkout Date']);
    } else {
      rows.add([
        'Full Name',
        'Department',
        'Designation',
        'Checkin Date',
        'Checkout Date'
      ]);
    }
    // Populate rows with data from AttendanceModel
    for (var attendance in data) {
      rows.add([
        attendance.fullName,
        attendance.course,
        attendance.year,
        formatTimestamp(attendance.checkin, 'MMM d, y, hh:mm a'),
        formatTimestamp(attendance.checkout, 'MMM d, y, hh:mm a'),
      ]);
    }

    // Create an Excel file
    var excel = Excel.createExcel();

    // Add the rows to the Excel file
    for (var row in rows) {
      var sheet = excel['Sheet1'];
      sheet.insertRowIterables(row, sheet.maxRows, overwriteMergedCells: true);
    }
    var random = Random();
    var randomNumbers = random.nextInt(1000); // Adjust as needed

    // Get the current date and time
    var now = DateTime.now();
    var formattedDate = DateFormat('MM_dd_yy-HHmmss').format(now);
    // Get the directory for saving the file
    String directory = await AndroidPathProvider.documentsPath;
    String filePath =
        '${directory}/attendance_data_${formattedDate}_$randomNumbers.xlsx';

    // Save the Excel file
    List<int>? excelBytes = excel.encode();
    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excelBytes!);
    Get.snackbar(
      'Succesfully',
      'Saved file in documents',
      backgroundColor: Colors.grey.withOpacity(0.8),
      colorText: Colors.white, // Adjust text color as needed
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
      // Adjust margin as needed
      borderRadius: 10, // Adjust border radius as needed
    );

    print('File saved at: $filePath');
  }

  String _selectedFilter = 'Course';
  @override
  Widget build(BuildContext context) {
    userController.loadUserData();
    DateTime dateTime = DateTime(1999, 8, 30, 12, 34);
    Timestamp mytimestamp = Timestamp.fromDate(dateTime);
    String? formatTime(Timestamp? timestamp) {
      if (timestamp == null) return null;
      if (timestamp.toDate() != mytimestamp.toDate()) {
        DateTime dateTime = timestamp.toDate();
        String formattedTime = DateFormat.jm().format(dateTime);
        return formattedTime;
      } else {
        return 'N/A';
      }
    }

    String? formatDate(Timestamp? timestamp) {
      if (timestamp == null) return null;
      DateTime dateTime = timestamp.toDate();
      String formattedDate = DateFormat('MMM d,yyyy').format(dateTime);
      print(timestamp.toString() + "  " + mytimestamp.toString());
      return formattedDate;
    }

    String UsertypeChecker = userController.user.value.usertype.toString();
    String UserEmail = userController.user.value.email.toString();
    String formattedStartDate =
        DateFormat('MMM d,yyyy').format(selectedDateRange.start);
    String formattedStartEnd =
        DateFormat('MMM d,yyyy').format(selectedDateRange.end);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text("${UsertypeChecker} Attendance"),
          actions: [
            IconButton(
              iconSize: 40,
              icon: Icon(
                Icons.calendar_today,
                color: Colors.lightBlueAccent,
              ),
              onPressed: () => _selectDateRange(context),
            ),
          ],
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${formattedStartDate} - ${formattedStartEnd} ',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    TextButton(
                        onPressed: _exportData,
                        child: Text(
                          'Export',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: TextButton.styleFrom(
                            backgroundColor:
                                Colors.lightBlueAccent, // Background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            )))
                  ]),
            ),
            Expanded(
              child: FutureBuilder<List<AttendanceModel>>(
                future: controller.getUserStudentAttendanceForDateRange(
                    selectedDateRange, UserEmail),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData && snapshot.data != null) {
                      filteredAttendance = snapshot.data!;
                      if (snapshot.data!.isNotEmpty) {
                        if (UsertypeChecker == "Student") {
                          return ListView.builder(
                            itemCount: snapshot.data!
                                .length, // Replace with the actual length of your list
                            itemBuilder: (BuildContext context, int index) {
                              final StudentData = snapshot.data![index];
                              return Card(
                                elevation: 4,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(10),
                                  leading: Icon(Icons.person_outline_outlined),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${StudentData.fullName}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      ),
                                      Text(
                                          "Course: ${StudentData.course} ${StudentData.year}"),
                                      Text(
                                          "Date: ${formatDate(StudentData.checkin)}"),
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "   IN: ${formatTime(StudentData.checkin)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Text(
                                          "OUT: ${formatTime(StudentData.checkout)}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18))
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          //Employee
                          return ListView.builder(
                            itemCount: snapshot.data!
                                .length, // Replace with the actual length of your list
                            itemBuilder: (BuildContext context, int index) {
                              final StudentData = snapshot.data![index];
                              return Card(
                                elevation: 4,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(10),
                                  leading: Icon(Icons.person_outline_outlined),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${StudentData.fullName}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      ),
                                      Text(
                                          "Department: ${StudentData.course} "),
                                      Text("Designation: ${StudentData.year}"),
                                      Text(
                                          "Date: ${formatDate(StudentData.checkin)}"),
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "   IN: ${formatTime(StudentData.checkin)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Text(
                                          "OUT: ${formatTime(StudentData.checkout)}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18))
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      } else {
                        return Center(
                          child: Text('No data for the selected date'),
                        );
                      }
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString() +
                            'Number of items: ${snapshot.data.toString()}'),
                      );
                    } else {
                      return const Center(
                        child: Text("Something went wrong"),
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )
          ],
        ));
  }

  String formatTimestamp(Timestamp? timestamp, String format) {
    if (timestamp == null) return '';

    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat(format).format(dateTime);
    return formattedDate;
  }
}
