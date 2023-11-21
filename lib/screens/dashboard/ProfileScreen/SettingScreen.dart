import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qr_attendance/screens/auth/EmployeeSignUp.dart';
import 'package:qr_attendance/screens/auth/signup.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white70,
        child: Column(
          children: [
            SizedBox(height: 20),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16),
              elevation: 5,
              child: ListTile(
                tileColor: Colors.lightBlueAccent.shade200,
                title: Text('Create Student Accounts'),
                onTap: () {
                  Get.to(() => SignUpScreen());
                },
              ),
            ),
            SizedBox(height: 20),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16),
              elevation: 5,
              child: ListTile(
                tileColor: Colors.lightBlueAccent.shade200,
                title: Text('Create Employee Accounts'),
                onTap: () {
                  // Add your logic to handle creating employee accounts
                  Get.to(() => EmployeeSignUpScreen());
                },
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Dismiss Signup on Welcome Screen',
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Switch(
                  //   value: true, // You can bind this to your switch state
                  //   onChanged: (bool value) {
                  //     // Add your logic to handle the switch state change
                  //     showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return AlertDialog(
                  //           title: Text('Confirmation'),
                  //           content: Text(
                  //               'Are you sure you want to change this setting?'),
                  //           actions: [
                  //             TextButton(
                  //               child: Text('Cancel'),
                  //               onPressed: () {
                  //                 Navigator.of(context).pop();
                  //               },
                  //             ),
                  //             TextButton(
                  //               child: Text('OK'),
                  //               onPressed: () async {
                  //                 await FirebaseFirestore.instance
                  //                     .collection('SignupToggle')
                  //                     .doc('iR0zeVn8DqgPvzYZymao')
                  //                     .update({'hideSignup': value});
                  //                 print(value.toString());
                  //                 print("sdasdasdas");
                  //                 Navigator.of(context).pop();
                  //               },
                  //             ),
                  //           ],
                  //         );
                  //       },
                  //     );
                  //   },
                  // ),
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('SignupToggle')
                        .doc('iR0zeVn8DqgPvzYZymao')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        bool hideSignup = snapshot.data!['hideSignup'];

                        return Switch(
                          value:
                              hideSignup, // Set the switch value based on Firebase data
                          onChanged: (bool value) async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirmation'),
                                  content: Text(
                                      'Are you sure you want to change this setting?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('SignupToggle')
                                            .doc('iR0zeVn8DqgPvzYZymao')
                                            .update({'hideSignup': value});
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
