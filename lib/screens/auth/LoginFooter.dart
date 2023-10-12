import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qr_attendance/screens/auth/signup.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // const Text("OR"),
        // const SizedBox(
        //   height: 10.0,
        // ),
        // SizedBox(
        //   width: double.infinity,
        //   child: OutlinedButton.icon(
        //       onPressed: () {},
        //       icon: Image(
        //         image: AssetImage(tGoogleImage),
        //         width: 20.0,
        //       ),
        //       label: Text("Sign-In with Google")),
        // ),
        const SizedBox(
          height: 10.0,
        ),
        TextButton(
            onPressed: () => Get.to(() => const SignUpScreen()),
            child: Text.rich(TextSpan(
                text: "Don't have an Account? ",
                style: Theme.of(context).textTheme.bodySmall,
                children: [
                  TextSpan(text: "Signup", style: TextStyle(color: Colors.blue))
                ])))
      ],
    );
  }
}
