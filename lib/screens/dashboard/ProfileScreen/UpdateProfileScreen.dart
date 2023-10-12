import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:modern_form_line_awesome_icons/modern_form_line_awesome_icons.dart';
import 'package:qr_attendance/screens/auth/controllers/profile_controller.dart';
import 'package:qr_attendance/screens/auth/models/user_model.dart';

import '../../constants/constants.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text(
          "EDIT PROFILE",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(LineAwesomeIcons.sun_o))
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: FutureBuilder(
            future: controller.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel userData = snapshot.data as UserModel;
                  return Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image(
                                image: AssetImage(tProfileImage),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.lightBlueAccent.shade100,
                              ),
                              child: Icon(
                                LineAwesomeIcons.camera,
                                size: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Form(
                          child: Column(
                        children: [
                          TextFormField(
                            initialValue: userData.fullName,
                            decoration: InputDecoration(
                                label: Text("Fullname"),
                                prefixIcon: Icon(
                                  Icons.person_outline_outlined,
                                  color: Colors.black,
                                ),
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Colors.black))),
                          ),
                          TextFormField(
                            initialValue: userData.email,
                            decoration: InputDecoration(
                                label: Text("Email"),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.black,
                                ),
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Colors.black))),
                          ),
                          TextFormField(
                            initialValue: userData.course,
                            decoration: InputDecoration(
                                label: Text("Course"),
                                prefixIcon: Icon(
                                  Icons.book_online_outlined,
                                  color: Colors.black,
                                ),
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Colors.black))),
                          ),
                          TextFormField(
                            initialValue: userData.year,
                            decoration: InputDecoration(
                                label: Text("Year"),
                                prefixIcon: Icon(
                                  Icons.numbers_outlined,
                                  color: Colors.black,
                                ),
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Colors.black))),
                          ),
                          TextFormField(
                            initialValue: userData.password,
                            decoration: InputDecoration(
                                label: Text("Password"),
                                prefixIcon: Icon(
                                  Icons.fingerprint_outlined,
                                  color: Colors.black,
                                ),
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Colors.white))),
                          ),
                          Text("Usertype : " + userData.usertype.toString()),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.lightBlueAccent.shade100,
                                  side: BorderSide.none,
                                  shape: const StadiumBorder()),
                              child: const Text(
                                "Edit Profile",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Text.rich(TextSpan(
                                  text: "Joined ",
                                  style: TextStyle(fontSize: 12),
                                  children: [
                                    TextSpan(
                                        text: userData.timestamp
                                            ?.toDate()
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12))
                                  ]))
                            ],
                          )
                        ],
                      ))
                    ],
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
        ),
      ),
    );
  }
}
