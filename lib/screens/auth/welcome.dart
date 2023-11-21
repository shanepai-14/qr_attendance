import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Dvciancheck/screens/auth/login.dart';
import 'package:Dvciancheck/screens/auth/signup.dart';
import 'package:Dvciancheck/screens/widgets/fade_in_animation/animation_design.dart';
import 'package:Dvciancheck/screens/widgets/fade_in_animation/animation_model.dart';
import 'package:Dvciancheck/screens/widgets/fade_in_animation/splash_screen_controller.dart';
import '../constants/constants.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late SplashScreenController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SplashScreenController());
    controller.startWelcomeAnimation();
  }

  @override
  Widget build(BuildContext context) {
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
              rightBefore: 0,
            ),
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
                              vertical: tButtonHeight,
                            ),
                          ),
                          child: Text("Login".toUpperCase()),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      // StreamBuilder<DocumentSnapshot>(
                      //   stream: FirebaseFirestore.instance
                      //       .collection('SignupToggle')
                      //       .doc('iR0zeVn8DqgPvzYZymao')
                      //       .snapshots(),
                      //   builder: (BuildContext context,
                      //       AsyncSnapshot<DocumentSnapshot> snapshot) {
                      //     if (snapshot.hasError) {
                      //       return Text('Error: ${snapshot.error}');
                      //     }
                      //     if (snapshot.connectionState ==
                      //         ConnectionState.waiting) {
                      //       return CircularProgressIndicator();
                      //     }
                      //     if (snapshot.hasData && snapshot.data != null) {
                      //       var hideSignup = snapshot.data!['hideSignup'];
                      //       return SignUpButtonWidget(hideSignup: hideSignup);
                      //     }
                      //     return Text('No Data');
                      //   },
                      // )
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

class SignUpButtonWidget extends StatelessWidget {
  final bool hideSignup;

  SignUpButtonWidget({required this.hideSignup});

  @override
  Widget build(BuildContext context) {
    return hideSignup
        ? Container()
        : Expanded(
            child: ElevatedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(),
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                side: BorderSide(color: Colors.black),
                padding: EdgeInsets.symmetric(
                  vertical: tButtonHeight,
                ),
              ),
              onPressed: () => Get.to(() => const SignUpScreen()),
              child: Text("Signup".toUpperCase()),
            ),
          );
  }
}
