import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:Dvciancheck/firebase_options.dart';
import 'package:Dvciancheck/screens/auth/controllers/user_controller.dart';
import 'package:Dvciancheck/screens/auth/welcome.dart';
import 'package:Dvciancheck/screens/repository/authentication_repository/authetication_repository.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Get.putAsync<UserController>(() async => UserController());
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
        .then((value) => Get.put(AuthenticationRepository()));
  } on Exception catch (e) {
    print("ERROR FIREBASE :" + e.toString());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dvciancheck',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}
