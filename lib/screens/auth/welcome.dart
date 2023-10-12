import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_attendance/screens/auth/login.dart';
import 'package:qr_attendance/screens/auth/signup.dart';
import 'package:qr_attendance/screens/widgets/fade_in_animation/animation_design.dart';
import 'package:qr_attendance/screens/widgets/fade_in_animation/animation_model.dart';
import 'package:qr_attendance/screens/widgets/fade_in_animation/splash_screen_controller.dart';

import '../constants/constants.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashScreenController());
    controller.startWelcomeAnimation();
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          TfadeAnimation(
            durationInMs: 1200,
            animatePosition: TanimatePosition(
                bottomAfter: 0,
                bottomBefore: -100,
                leftAfter: 0,
                leftBefore: 0,
                topAfter: 0,
                topBefore: 0,
                rightAfter: 0,
                rightBefore: 0),
            child: Container(
              padding: EdgeInsets.all(tDefaultSize),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image(
                    image: AssetImage(tWelcomeScreenImage),
                    height: height * 0.6,
                  ),
                  Column(
                    children: [
                      Text(
                        tWelcomeTitle,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        tWelcomeSubTitle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                            onPressed: () => Get.to(() => const LoginScreen()),
                            style: OutlinedButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(),
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.black),
                                padding: EdgeInsets.symmetric(
                                    vertical: tButtonHeight)),
                            child: Text("Login".toUpperCase())),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                          child: ElevatedButton(
                              style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(),
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.black,
                                  side: BorderSide(color: Colors.black),
                                  padding: EdgeInsets.symmetric(
                                      vertical: tButtonHeight)),
                              onPressed: () =>
                                  Get.to(() => const SignUpScreen()),
                              child: Text("Signup".toUpperCase())))
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
