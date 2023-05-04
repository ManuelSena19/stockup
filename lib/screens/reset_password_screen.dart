import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stockup/constants/routes.dart';
import 'package:stockup/utilities/show_error_dialog.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  void validator(emailController) =>
      emailController != null && !EmailValidator.validate(emailController)
          ? 'Enter a valid email'
          : null;

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
    } on FirebaseAuthException catch (e) {
      showErrorDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue,),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 100, 0, 10),
              child: Text(
                'Enter e-mail to reset password',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Form(
              key: formKey,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: TextField(
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email)
                  ),
                ),
              ),
            ),
            Container(
              height: 60,
              padding: const EdgeInsets.fromLTRB(100, 10, 100, 10),
              child: ElevatedButton(
                onPressed: (){
                  resetPassword();
                  Navigator.of(context).pushNamed(loginRoute);
                },
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Reset",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}