import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:modern_form_line_awesome_icons/modern_form_line_awesome_icons.dart';
import 'package:qr_attendance/screens/auth/models/attendance_model.dart';
import 'package:qr_attendance/screens/dashboard/ProfileScreen/ProfileScreen.dart';

import '../../../auth/controllers/profile_controller.dart';

class GuardAttendanceScreen extends StatefulWidget {
  const GuardAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<GuardAttendanceScreen> createState() => _GuardAttendanceScreenState();
}

DateTime selectedDate = DateTime.now();

class _GuardAttendanceScreenState extends State<GuardAttendanceScreen> {
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
  bool _isSearchExpanded = false;
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
              : Text("Student Attendance"),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: courseCategories.map((course) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0), // Adjust the padding as needed
                  child: FilterChip(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: yearCategories.map((years) {
                return FilterChip(
                  materialTapTargetSize:
                      MaterialTapTargetSize.shrinkWrap, // Adjust the hit area
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
            Expanded(
              child: FutureBuilder<List<AttendanceModel>>(
                future: controller.getAttendanceForDateRange(selectedDateRange),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<AttendanceModel> filteredAttendance = snapshot.data!;
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
                                  Text(
                                      "Course: ${StudentData.course} ${StudentData.year}"),
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
}
