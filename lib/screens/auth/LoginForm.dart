import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:Dvciancheck/screens/auth/buildShowModalBottomSheet.dart';
import 'package:Dvciancheck/screens/auth/welcome.dart';
import 'ForgotPasswordBtnWidget.dart';
import 'controllers/signup_contoller.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final controller = Get.put(SignUpController());
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
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
                hintText: "Email",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: controller.password,
              obscureText: obscurePassword,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.fingerprint_outlined),
                labelText: "Password",
                hintText: "Password ",
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                  icon: Icon(
                    obscurePassword
                        ? Icons.remove_red_eye_sharp
                        : Icons.visibility_off,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  ForgotPasswordScreen.buildShowModalBottomSheet(context);
                },
                child: Text("Forgot password?"),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  SignUpController.instance.LoginUser(
                    controller.email.text.trim(),
                    controller.password.text.trim(),
                  );
                },
                child: Text("LOGIN"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
