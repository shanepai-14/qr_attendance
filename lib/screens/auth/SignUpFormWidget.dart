import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qr_attendance/screens/auth/controllers/signup_contoller.dart';
import 'package:qr_attendance/screens/auth/models/user_model.dart';
import 'package:qr_attendance/screens/repository/user_repository/user_repository.dart';

class SignUpFormWidget extends StatelessWidget {
  const SignUpFormWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    final _formKey = GlobalKey<FormState>();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.fullname,
              decoration: InputDecoration(
                  label: Text("Fullname"),
                  prefixIcon: Icon(
                    Icons.person_outline_outlined,
                    color: Colors.black,
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.black))),
            ),
            TextFormField(
              controller: controller.email,
              decoration: InputDecoration(
                  label: Text("Email"),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Colors.black,
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.black))),
            ),
            TextFormField(
              controller: controller.phone,
              decoration: InputDecoration(
                  label: Text("Phone"),
                  prefixIcon: Icon(
                    Icons.phone_android_outlined,
                    color: Colors.black,
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.black))),
            ),
            TextFormField(
              controller: controller.course,
              decoration: InputDecoration(
                  label: Text("Course"),
                  prefixIcon: Icon(
                    Icons.book_online_outlined,
                    color: Colors.black,
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.black))),
            ),
            TextFormField(
              controller: controller.year,
              decoration: InputDecoration(
                  label: Text("Year"),
                  prefixIcon: Icon(
                    Icons.school_outlined,
                    color: Colors.black,
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.black))),
            ),
            TextFormField(
              controller: controller.password,
              decoration: InputDecoration(
                  label: Text("Password"),
                  prefixIcon: Icon(
                    Icons.fingerprint_outlined,
                    color: Colors.black,
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.white))),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      //Email & Password Authentication
                      // SignUpController.instance.registerUser(
                      //     controller.email.text.trim(),
                      //     controller.password.text.trim());

                      final user = UserModel(
                          email: controller.email.text.trim(),
                          password: controller.password.text.trim(),
                          fullName: controller.fullname.text.trim(),
                          course: controller.course.text.trim(),
                          phoneNo: controller.phone.text.trim(),
                          year: controller.year.text.trim());

                      SignUpController.instance.createUser(
                          user,
                          controller.email.text.trim(),
                          controller.password.text.trim());
                    }
                  },
                  child: const Text("SIGNUP")),
            )
          ],
        ),
      ),
    );
  }
}
