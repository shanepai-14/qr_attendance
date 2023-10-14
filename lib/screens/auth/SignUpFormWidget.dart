import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance/screens/auth/controllers/signup_contoller.dart';
import 'package:qr_attendance/screens/auth/models/user_model.dart';
import 'package:qr_attendance/screens/repository/user_repository/user_repository.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({
    super.key,
  });

  @override
  _SignUpFormWidgetState createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  String? selectedCourse;
  String? selectedYear;
  bool obscurePassword = true;
  final controller = Get.put(SignUpController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus(); // Dismiss keyboard
              },
              child: TextFormField(
                controller: controller.phone,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  label: Text("Phone"),
                  prefixIcon: Icon(
                    Icons.phone_android_outlined,
                    color: Colors.black,
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0, color: Colors.black),
                  ),
                ),
              ),
            ),
            DropdownButtonFormField<String>(
              value: selectedCourse,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCourse = newValue;
                });
              },
              items: <String>['BSIT', 'BEED', 'BSED', 'THEO', 'SHS']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: "Course",
                prefixIcon: Icon(
                  Icons.book_online_outlined,
                  color: Colors.black,
                ),
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2.0, color: Colors.black),
                ),
              ),
            ),
            DropdownButtonFormField<String>(
              value: selectedYear,
              onChanged: (String? newValue) {
                setState(() {
                  selectedYear = newValue;
                });
              },
              items: <String>[
                '1st Year',
                '2nd Year',
                '3rd Year',
                '4th Year',
                'Grade 11',
                'Grade 12',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: "Year",
                prefixIcon: Icon(
                  Icons.book_online_outlined,
                  color: Colors.black,
                ),
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2.0, color: Colors.black),
                ),
              ),
            ),
            TextFormField(
              controller: controller.password,
              obscureText:
                  obscurePassword, // Use obscurePassword to hide/unhide password
              decoration: InputDecoration(
                label: Text("Password"),
                prefixIcon: Icon(
                  Icons.fingerprint_outlined,
                  color: Colors.black,
                ),
                labelStyle: TextStyle(color: Colors.black),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2.0, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final user = UserModel(
                          email: controller.email.text.trim(),
                          password: controller.password.text.trim(),
                          fullName: controller.fullname.text.trim(),
                          course: selectedCourse,
                          phoneNo: controller.phone.text.trim(),
                          year: selectedYear,
                          usertype: "Student");

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
