import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:Dvciancheck/screens/auth/forgot_password_otp/otp_screen.dart';

import '../../constants/constants.dart';
import '../../widgets/form/FormHeaderWidget.dart';

class ForgotPasswordMailScreen extends StatelessWidget {
  const ForgotPasswordMailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                FormHeaderWidget(
                  width: 0.4,
                  image: tForgotPassImage,
                  title: "Forget Password",
                  subTitle:
                      "Select one the options given below to reset your password",
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                    child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          label: Text("Email"),
                          hintText: "Email",
                          prefixIcon: Icon(Icons.mail_outline_rounded)),
                    )
                  ],
                )),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => const OTPScreen());
                      },
                      child: const Text("NEXT")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
