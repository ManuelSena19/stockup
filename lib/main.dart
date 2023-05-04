import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stockup/constants/routes.dart';
import 'package:stockup/screens/home_screen.dart';
import 'package:stockup/screens/login_screen.dart';
import 'package:stockup/screens/register_screen.dart';
import 'package:stockup/screens/reset_password_screen.dart';
import 'package:stockup/screens/verify_email_screen.dart';
import 'constants/logic.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockUp',
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? loginRoute
          : homescreenRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        loginRoute: (context) => const LoginScreen(),
        logicRoute: (context) => const Logic(),
        registerRoute: (context) => const RegisterScreen(),
        verifyEmailRoute: (context) => const VerifyEmailScreen(),
        resetPasswordRoute: (context) => const ResetPasswordScreen(),
        homescreenRoute: (context) => const HomeScreen()
      },
    );
  }
}
