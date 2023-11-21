import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:Dvciancheck/screens/auth/login.dart';
import 'package:Dvciancheck/screens/constants/constants.dart';
import 'package:Dvciancheck/screens/widgets/form/FormHeaderWidget.dart';

import 'EmployeeSignUpFormWidget.dart';
import 'SignUpFormWidget.dart';

class EmployeeSignUpScreen extends StatelessWidget {
  const EmployeeSignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(children: [
            FormHeaderWidget(
                width: 0.2,
                image: tWelcomeScreenImage,
                title: "Signup",
                subTitle: "Create an Employee account"),
            EmployeeSignUpFormWidget(),
          ])),
    ));
  }
}
