import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qr_attendance/screens/auth/buildShowModalBottomSheet.dart';

import 'ForgotPasswordBtnWidget.dart';
import 'controllers/signup_contoller.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    return Form(
        child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller.email,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline_outlined),
                labelText: "Email",
                hintText: "Email"),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: controller.password,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.fingerprint_outlined),
                labelText: "Password",
                hintText: "Password ",
                suffixIcon: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.remove_red_eye_sharp),
                )),
          ),
          SizedBox(
            height: 10,
          ),
          //FORGOT PASSWORD BUTTON
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: () {
                  ForgotPasswordScreen.buildShowModalBottomSheet(context);
                },
                child: Text("Forgot password?")),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                SignUpController.instance.LoginUser(
                    controller.email.text.trim(),
                    controller.password.text.trim());
              },
              child: Text("LOGIN"),
            ),
          )
        ],
      ),
    ));
  }
}
