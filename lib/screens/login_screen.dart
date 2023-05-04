import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stockup/utilities/show_error_dialog.dart';
import 'package:stockup/constants/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController emailController = TextEditingController();
  late final TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;
  final formKey = GlobalKey<FormState>();

  void validator(emailController) =>
      emailController != null && !EmailValidator.validate(emailController)
          ? 'Enter a valid email'
          : null;

  void pushRoute(String route) {
    Navigator.pushNamed(context, route);
  }

  void pushReplacementRoute(String route) {
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SizedBox(width: 150,),
          Expanded(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(10, 150, 10, 50),
                  child: const Text(
                    'StockUp',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Form(
                  key: formKey,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                    child: TextField(
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          labelText: 'E-mail',
                          prefixIcon: Icon(Icons.email)),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 30),
                  child: TextField(
                    obscureText: _isObscure,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: Icon(_isObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        String email = emailController.text;
                        String password = passwordController.text;
                        final form = formKey.currentState!;
                        if (form.validate()) {}
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email, password: password);
                        pushReplacementRoute(logicRoute);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          await showErrorDialog(context, 'User not found');
                        } else if (e.code == 'wrong-password') {
                          await showErrorDialog(context, 'Wrong password');
                        } else {
                          await showErrorDialog(context, 'Error: $e.code');
                        }
                      } catch (e) {
                        await showErrorDialog(context, e.toString());
                      }
                    },
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Sign In",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Does not have an account?',
                      style: TextStyle(fontSize: 15),
                    ),
                    TextButton(
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                        pushReplacementRoute(registerRoute);
                      },
                    ),
                  ],
                ),
                TextButton(
                    onPressed: () {
                      pushRoute(resetPasswordRoute);
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(fontSize: 15),
                    )),
              ],
            ),
          ),
          const Expanded(
            child: VerticalDivider(
              thickness: 5,
              color: Colors.lightBlueAccent,
              indent: 70,
              endIndent: 70,
            ),
          ),
          Expanded(
            child: Column(
              children: const [
                Image(
                  image: AssetImage("assets/logo.jpg"),
                  fit: BoxFit.fitWidth,
                  height: 700,
                )
              ],
            ),
          ),
          const SizedBox(width: 50,),
        ],
      ),
    );
  }
}
