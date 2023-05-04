import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stockup/constants/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockup/utilities/show_error_dialog.dart';
import 'package:stockup/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firestore = FirebaseFirestore.instance;
  late final TextEditingController usernameController = TextEditingController();
  late final TextEditingController passwordController = TextEditingController();
  late final TextEditingController emailController = TextEditingController();
  String? gender;
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

  Future<void> addUser(String email, String username) async {
    final CollectionReference users = _firestore.collection('users');
    await users.doc(email).set({
      'username': username,
      'email': email,
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Row(
                  children: [
                    const SizedBox(width: 150,),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(10, 120, 10, 50),
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
                              'Register',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                            child: TextField(
                              autocorrect: false,
                              keyboardType: TextInputType.text,
                              controller: usernameController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  labelText: 'Username',
                                  prefixIcon: Icon(Icons.person)),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                            child: TextField(
                              obscureText: _isObscure,
                              enableSuggestions: false,
                              autocorrect: false,
                              controller: passwordController,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
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
                                  )),
                            ),
                          ),
                          Form(
                            key: formKey,
                            child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 20, 10, 30),
                              child: TextField(
                                autofillHints: const [AutofillHints.email],
                                autocorrect: false,
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  labelText: 'E-mail',
                                  prefixIcon: Icon(Icons.email),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 60,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 100),
                            child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  String username = usernameController.text;
                                  String email = emailController.text;
                                  String password = passwordController.text;
                                  final form = formKey.currentState!;
                                  if (form.validate()) {}
                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email: email, password: password);
                                  addUser(email, username);
                                  pushReplacementRoute(logicRoute);
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    await showErrorDialog(context,
                                        "Weak password : Password should be above 6 characters");
                                  } else if (e.code == 'invalid-password') {
                                    await showErrorDialog(
                                        context, 'Invalid-password');
                                  } else if (e.code == 'email-already-in-use') {
                                    await showErrorDialog(context,
                                        'Email belongs to other user: Register with a different email');
                                  } else {
                                    await showErrorDialog(
                                        context, 'Error: $e.code');
                                  }
                                } on TypeError catch (e) {
                                  await showErrorDialog(context, e.toString());
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
                                    "Register",
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
                                'Already have an account?',
                                style: TextStyle(fontSize: 15),
                              ),
                              TextButton(
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(fontSize: 15),
                                ),
                                onPressed: () {
                                  pushReplacementRoute(loginRoute);
                                },
                              ),
                            ],
                          ),
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
                    const SizedBox(width: 50,)
                  ],
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
