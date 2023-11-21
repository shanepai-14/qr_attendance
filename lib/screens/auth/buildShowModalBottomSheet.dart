import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Dvciancheck/screens/auth/forgot_password_mail/forgot_password_mail.dart';

import 'ForgotPasswordBtnWidget.dart';

class ForgotPasswordScreen {
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        builder: (context) => Container(
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Make Selection!",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    "Select one of the options given below to reset your password",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  ForgotPasswordBtnWidget(
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => ForgotPasswordMailScreen());
                      },
                      btnIcon: Icons.mail_outline,
                      title: "Email",
                      subtitle: "Reset via E-Mail Verification"),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ForgotPasswordBtnWidget(
                      onTap: () {},
                      btnIcon: Icons.mobile_friendly_rounded,
                      title: "Phone No",
                      subtitle: "Reset via Phone Verification")
                ],
              ),
            ));
  }
}
