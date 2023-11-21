import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:Dvciancheck/screens/auth/models/attendance_model.dart';
import 'package:Dvciancheck/screens/dashboard/ProfileScreen/ProfileScreen.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:android_path_provider/android_path_provider.dart';

class EmployeeAttendanceScreen extends StatefulWidget {
  const EmployeeAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeAttendanceScreen> createState() =>
      _EmployeeAttendanceScreenState();
}

DateTime selectedDate = DateTime.now();

class _EmployeeAttendanceScreenState extends State<EmployeeAttendanceScreen> {
  final List<String> courseCategories = [
    'BSIT',
    'BSED',
    'BEED',
    'THEO',
    'REGISTRAR'
  ];
  final List<String> yearCategories = [
    'Teacher',
    'Office staff',
    'Management',
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
    rows.add(['Full Name', 'Course', 'Year', 'Checkin Date', 'Checkout Date']);

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

  bool _isSearchExpanded = false;
  String _selectedFilter = 'Course';
  @override
  Widget build(BuildContext context) {
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

    String formattedStartDate =
        DateFormat('MMM d,yyyy').format(selectedDateRange.start);
    String formattedStartEnd =
        DateFormat('MMM d,yyyy').format(selectedDateRange.end);
    return Scaffold(
        appBar: AppBar(
          leading: _isSearchExpanded
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearchExpanded = false;
                    });
                  },
                  icon: Icon(Icons.arrow_back),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearchExpanded = true;
                    });
                  },
                  icon: Icon(Icons.search),
                ),
          title: _isSearchExpanded
              ? TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                  ),
                )
              : Text("Employee Attendance"),
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
            Column(
              children: [
                Visibility(
                  visible: _isSearchExpanded,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: courseCategories.map((course) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 0), // Adjust the padding as needed
                        child: FilterChip(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          selectedColor: Colors.lightBlueAccent,
                          label: Text(course),
                          selected: selectedCourses.contains(course),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                selectedCourses.add(course);
                              } else {
                                selectedCourses.remove(course);
                              }
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Visibility(
                  visible: _isSearchExpanded,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: yearCategories.map((years) {
                      return FilterChip(
                        materialTapTargetSize: MaterialTapTargetSize
                            .shrinkWrap, // Adjust the hit area
                        // Customize background color
                        selectedColor:
                            Colors.lightBlueAccent, // Customize selected color
                        label: Text(years),
                        selected: selectedYears.contains(years),
                        onSelected: (bool selected) {
                          setState(() {
                            setState(() {
                              if (selected) {
                                selectedYears.add(years);
                              } else {
                                selectedYears.remove(years);
                              }
                            });
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
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
                future: controller
                    .getAttendanceEmployeeForDateRange(selectedDateRange),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      filteredAttendance = snapshot.data!;
                      if (filteredAttendance.isNotEmpty) {
                        if (selectedCourses.isNotEmpty) {
                          filteredAttendance =
                              filteredAttendance.where((attendance) {
                            return selectedCourses.contains(attendance.course);
                          }).toList();
                        }
                        if (selectedYears.isNotEmpty) {
                          filteredAttendance =
                              filteredAttendance.where((attendance) {
                            return selectedYears.contains(attendance.year);
                          }).toList();
                        }
                        if (searchQuery.isNotEmpty) {
                          filteredAttendance =
                              filteredAttendance.where((attendance) {
                            return attendance.fullName
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase());
                          }).toList();
                        }
                        return ListView.builder(
                          itemCount: filteredAttendance
                              .length, // Replace with the actual length of your list
                          itemBuilder: (BuildContext context, int index) {
                            final StudentData = filteredAttendance[index];
                            return Card(
                              elevation: 4,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(10),
                                leading: Icon(Icons.person_outline_outlined),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${StudentData.fullName}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                    Text("Department: ${StudentData.course}"),
                                    Text("Designation: ${StudentData.year}"),
                                    Text(
                                        "Date: ${formatDate(StudentData.checkin)}"),
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
