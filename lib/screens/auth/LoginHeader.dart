import 'package:flutter/material.dart';

import '../constants/constants.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(
          image: AssetImage(tWelcomeScreenImage),
          height: size.height * 0.3,
        ),
        Text(
          "Login Sample",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          tLoginSub,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
