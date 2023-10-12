import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:modern_form_line_awesome_icons/modern_form_line_awesome_icons.dart';
import 'package:qr_attendance/screens/auth/forgot_password_otp/Logout.dart';
import 'package:qr_attendance/screens/constants/constants.dart';
import 'package:qr_attendance/screens/dashboard/ProfileScreen/UpdateProfileScreen.dart';

import '../../auth/controllers/profile_controller.dart';
import '../../auth/models/user_model.dart';
import 'ProfileScreenWidget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

final controller = Get.put(ProfileController());

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {}, icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text(
          "Profile",
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
                String imagePath = userData.usertype.toString() == "Student"
                    ? StudentImage
                    : GuardImage;
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
                              image: AssetImage(imagePath),
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
                              LineAwesomeIcons.pencil,
                              size: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      userData.fullName.toString(),
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Text(
                      userData.usertype.toString(),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(() => const UpdateProfileScreen());
                        },
                        child: const Text(
                          "EDIT PROFILE",
                          style: const TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent.shade200,
                            side: BorderSide.none,
                            shape: StadiumBorder()),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    ProfileMenuWidget(
                      title: "Settings",
                      icon: LineAwesomeIcons.cog,
                      onPress: () {},
                    ),
                    ProfileMenuWidget(
                      title: "Information",
                      icon: LineAwesomeIcons.info,
                      onPress: () {},
                    ),
                    const Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    ProfileMenuWidget(
                      title: "Logout",
                      icon: LineAwesomeIcons.sign_out,
                      textColor: Colors.redAccent,
                      endIcon: false,
                      onPress: () {
                        logOut();
                      },
                    ),
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
      )),
    );
  }
}
