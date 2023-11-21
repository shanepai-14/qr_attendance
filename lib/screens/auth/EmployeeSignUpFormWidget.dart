import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qr_attendance/screens/auth/controllers/signup_contoller.dart';
import 'package:qr_attendance/screens/auth/models/user_model.dart';
import 'package:qr_attendance/screens/repository/user_repository/user_repository.dart';

class EmployeeSignUpFormWidget extends StatefulWidget {
  const EmployeeSignUpFormWidget({Key? key}) : super(key: key);

  @override
  _EmployeeSignUpFormWidgetState createState() =>
      _EmployeeSignUpFormWidgetState();
}

class _EmployeeSignUpFormWidgetState extends State<EmployeeSignUpFormWidget> {
  bool obscurePassword = true;
  String? selectedCourse;
  String? selectedYear;
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
              value: selectedCourse, // Use the selectedCourse variable
              onChanged: (String? newValue) {
// Update the selectedCourse when the user selects an option
                selectedCourse = newValue;
              },
              items: <String>['BSIT', 'BEED', 'BSED', 'THEO', 'SHS']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: "Department",
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
              value: selectedCourse, // Use the selectedCourse variable
              onChanged: (String? newValue) {
// Update the selectedCourse when the user selects an option
                selectedCourse = newValue;
              },
              items: <String>[
                'Teacher',
                'Office Staff',
                'Registrar',
                'Management',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: "Designation",
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
// Add this line
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
//Email & Password Authentication
// SignUpController.instance.registerUser(
//     controller.email.text.trim(),
//     controller.password.text.trim());

                      final user = UserModel(
                          email: controller.email.text.trim(),
                          password: controller.password.text.trim(),
                          fullName: controller.fullname.text.trim(),
                          course: selectedCourse,
                          phoneNo: controller.phone.text.trim(),
                          year: selectedYear,
                          usertype: "Employee");

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
