import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_attendance/screens/auth/welcome.dart';

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
        // TextButton(
        //     onPressed: () {},
        //     child: Text.rich(TextSpan(
        //         text: "Don't have an Account? ",
        //         style: Theme.of(context).textTheme.bodySmall,
        //         children: [
        //           TextSpan(text: "Signup", style: TextStyle(color: Colors.blue))
        //         ]))),
        Wrap(children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('SignupToggle')
                .doc('iR0zeVn8DqgPvzYZymao')
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasData && snapshot.data != null) {
                var hideSignup = snapshot.data!['hideSignup'];
                return SignUpButtonWidget(hideSignup: hideSignup);
              }
              return Text('No Data');
            },
          )
        ])
      ],
    );
  }
}
