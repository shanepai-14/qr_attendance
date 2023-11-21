import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:Dvciancheck/screens/auth/login.dart';
import 'package:Dvciancheck/screens/constants/constants.dart';
import 'package:Dvciancheck/screens/widgets/form/FormHeaderWidget.dart';

import 'SignUpFormWidget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

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
                subTitle: "Create an account"),
            SignUpFormWidget(),
            Column(
              children: [
                // const Text("OR"),
                // SizedBox(
                //   height: 20,
                // ),
                // SizedBox(
                //   width: double.infinity,
                //   child: OutlinedButton.icon(
                //       onPressed: () {},
                //       icon: const Image(
                //         image: AssetImage(tGoogleImage),
                //         width: 20.0,
                //       ),
                //       label: Text("Sign-in with Google")),
                // ),
                TextButton(
                  onPressed: () => Get.to(() => const LoginScreen()),
                  child: Text.rich(TextSpan(
                      text: "Already have an Account? ",
                      style: Theme.of(context).textTheme.bodySmall,
                      children: [
                        TextSpan(
                            text: "LOGIN", style: TextStyle(color: Colors.blue))
                      ])),
                )
              ],
            ),
          ])),
    ));
  }
}
