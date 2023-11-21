import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:modern_form_line_awesome_icons/modern_form_line_awesome_icons.dart';

import 'package:intl/intl.dart';
import 'package:qr_attendance/screens/dashboard/ListScreen/StudentAttendanceScreen.dart';
import '../../auth/controllers/user_controller.dart';
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
final UserController userController = Get.find<UserController>();

class _ScannerScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    userController.loadUserData();
    DateTime now = DateTime.now();
    String formattedTime = DateFormat.jm().format(now);
    String formattedDate = DateFormat('EEEE, MMMM d').format(now);

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
          "Attendance",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          IconButton(
            iconSize: 40,
            icon: Icon(
              Icons.heart_broken_sharp,
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
                        "Welcome " +
                            userController.user.value.fullName.toString(),
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          formattedTime,
                          style: TextStyle(
                              fontSize: 42, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          formattedDate,
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Todays Attendance",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
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
                    Text(
                      "Reminder : Dont forget to check in check out",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        // Add your onTap logic here
                        Get.to(() => const StudentAttendanceScreen());
                      },
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(
                            'View Attendance',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'History',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          trailing: Icon(
                            Icons.calendar_today,
                            size: 40,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    )
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
                        "Welcome " +
                            userController.user.value.fullName.toString(),
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          formattedTime,
                          style: TextStyle(
                              fontSize: 42, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          formattedDate,
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Todays Attendance",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
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
                                    Text("--/--",
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
                    Text(
                      "Reminder : Dont forget to check in check out",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        // Add your onTap logic here
                        Get.to(() => const StudentAttendanceScreen());
                      },
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(
                            'View Attendance',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'History',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          trailing: Icon(
                            Icons.calendar_today,
                            size: 40,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    )
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
