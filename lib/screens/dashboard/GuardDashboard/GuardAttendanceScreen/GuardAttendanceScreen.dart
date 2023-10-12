import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modern_form_line_awesome_icons/modern_form_line_awesome_icons.dart';
import 'package:qr_attendance/screens/auth/models/attendance_model.dart';
import 'package:qr_attendance/screens/dashboard/ProfileScreen/ProfileScreen.dart';

class GuardAttendanceScreen extends StatefulWidget {
  const GuardAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<GuardAttendanceScreen> createState() => _GuardAttendanceScreenState();
}

class _GuardAttendanceScreenState extends State<GuardAttendanceScreen> {
  DateTime selectedDate = DateTime.now(); // Initialize with current date

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
              onPressed: () => _selectDate(context),
            ),
          ],
          centerTitle: true,
        ),
        body: FutureBuilder<List<AttendanceModel>>(
          future: controller.getAttendanceForDate(selectedDate),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!
                      .length, // Replace with the actual length of your list
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        leading: Icon(Icons.person_outline_outlined),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${snapshot.data![index].fullName}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                            Text(
                                "Course: ${snapshot.data![index].course} ${snapshot.data![index].year}"),
                            Text(
                                "Date: ${formatDate(snapshot.data![index].checkin)}"),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "   IN: ${formatTime(snapshot.data![index].checkin)}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                                "OUT: ${formatTime(snapshot.data![index].checkout)}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18))
                          ],
                        ),
                      ),
                    );
                  },
                );

                // return ListView.builder(
                //     shrinkWrap: true,
                //     itemCount: snapshot.data!.length,
                //     itemBuilder: (c, index) {
                //       return Padding(
                //         padding: const EdgeInsets.symmetric(
                //             vertical: 3,
                //             horizontal: 3), // Increase padding here
                //         child: Card(
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10),
                //           ),
                //           clipBehavior: Clip.antiAliasWithSaveLayer,
                //           child: ListTile(
                //             leading: Container(
                //               width: 50,
                //               height: 50,
                //               child: Icon(LineAwesomeIcons.user),
                //             ),
                //             title: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: <Widget>[
                //                 Text(
                //                   snapshot.data![index].fullName,
                //                   style: TextStyle(
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //                 SizedBox(height: 5),
                //                 Text(
                //                   snapshot.data![index].course +
                //                       " " +
                //                       snapshot.data![index].year,
                //                   style: TextStyle(color: Colors.grey[500]),
                //                 ),
                //                 SizedBox(height: 10),
                //               ],
                //             ),
                //             trailing: Text(
                //               snapshot.data![index].checkin!
                //                   .toDate()
                //                   .toString(),
                //               style: TextStyle(
                //                 fontWeight: FontWeight.bold,
                //                 fontSize: 30,
                //                 color: Colors.grey[700],
                //               ),
                //             ),
                //           ),
                //         ),
                //       );
                //
                //       //   Column(
                //       //   children: [
                //       //     SizedBox(height: 10),
                //       //     ListTile(
                //       //       iconColor: Colors.blue,
                //       //       tileColor: Colors.blue.withOpacity(0.1),
                //       //       leading: const Icon(LineAwesomeIcons.user),
                //       //       title: Text(
                //       //           "Name:  ${snapshot.data![index].fullName}"),
                //       //       subtitle: Column(
                //       //         crossAxisAlignment: CrossAxisAlignment.start,
                //       //         children: [
                //       //           Text(
                //       //               "Phone# : ${snapshot.data![index].phoneNo}"),
                //       //           Text(snapshot.data![index].email),
                //       //           Text(
                //       //               "Course :${snapshot.data![index].course}   Year : ${snapshot.data![index].year}"),
                //       //           Text(
                //       //               "Time in :${snapshot.data![index].timestamp?.toDate().toString()}   Entry : ${snapshot.data![index].entry}"),
                //       //         ],
                //       //       ),
                //       //     )
                //       //   ],
                //       // );
                //     });
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
        ));
  }
}
