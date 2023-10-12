import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:modern_form_line_awesome_icons/modern_form_line_awesome_icons.dart';

import 'package:intl/intl.dart';
import '../../auth/models/attendance_model.dart';
import '../../repository/authentication_repository/authetication_repository.dart';
import '../../repository/user_repository/user_repository.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ScannerScreenState();
}

final _authRepo = Get.put(AuthenticationRepository());
final _userRepo = Get.put(UserRepository());

class _ScannerScreenState extends State<ListScreen> {
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
        return '--/--';
      }
    }

    final email = _authRepo.firebaseUser.value?.email;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {}, icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text(
          "Student Attendance",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          IconButton(
            iconSize: 40,
            icon: Icon(
              Icons.calendar_today,
              color: Colors.lightBlueAccent,
            ),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _userRepo.getUsersAttendanceToday(email!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                AttendanceModel attendanceData =
                    snapshot.data as AttendanceModel;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Welcome User",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "CHECK IN",
                                      style: TextStyle(
                                        fontSize: 25,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                        formatTime(attendanceData.checkin)
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "CHECK OUT",
                                      style: TextStyle(
                                        fontSize: 25,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                        formatTime(attendanceData.checkout)
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                Get.snackbar("Reminder", "Dont forgot get to check in",
                    snackPosition: SnackPosition.TOP,
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.blue.shade200,
                    colorText: Colors.white);
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Welcome User",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "CHECK IN",
                                      style: TextStyle(
                                        fontSize: 25,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text("--/--".toString(),
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "CHECK OUT",
                                      style: TextStyle(
                                        fontSize: 25,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text("--/--",
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
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
      ),
    );
  }
}
