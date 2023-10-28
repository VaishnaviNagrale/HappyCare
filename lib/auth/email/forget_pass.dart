// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happycare/auth/email/email_pass_login.dart';
import 'package:happycare/auth/email/email_pass_signup.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  TextEditingController emailController = TextEditingController();

  ResetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.amber,
          content: Text(
            'Password Reset Email Has Been Sent',
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const EmailPassLoginScreen(),
        ),
      );
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        print('No user found for that email!');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.amber,
            content: Text(
              'No user found for that email!',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/forget.jpg'),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: const Text(
              'Reset link will be send to your Email Id',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        autofocus: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: 15.0,
                          ),
                        ),
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter email';
                          } else if (!value.contains('@')) {
                            return 'please enter a vaild email';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 20.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  email = emailController.text;
                                });
                                ResetPassword();
                              }
                            },
                            child: const Text(
                              'Send Email',
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EmailPassLoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Donot have an account?',
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, a, b) => const EmailPassSignUp(),
                                transitionDuration: const Duration(seconds: 0),
                              ),
                            );
                          },
                          child: const Text(
                            'SignUp',
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}