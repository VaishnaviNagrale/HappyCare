// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happycare/auth/email/forget_pass.dart';
import 'package:happycare/auth/signup_page.dart';
import 'package:happycare/screens/doctor/doctors_home_screen.dart';
import 'package:happycare/screens/nurse/nurse_home_screen.dart';
import 'package:happycare/screens/staff/staff_home_screen.dart';

class EmailPassLoginScreen extends StatefulWidget {
  const EmailPassLoginScreen({Key? key}) : super(key: key);

  @override
  State<EmailPassLoginScreen> createState() => _EmailPassLoginScreenState();
}

class _EmailPassLoginScreenState extends State<EmailPassLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? email;
  String? password;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> fetchData(String userEmail) async {
      final firestore = FirebaseFirestore.instance;
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        final userType = userData[
            'userType']; // This will contain 'doctor', 'nurse', or 'staff'.
        final Name = userData['name'];
        final mobileNo = userData['mobileNo'];
        final idNo = userData['idNo'];

        // Now you can check the userType and take appropriate actions.
        if (userType == 'UserType.doctor') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorsHomeScreen(
                userEmail: userEmail,
              ),
            ),
          );
        } else if (userType == 'UserType.nurse') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NurseHomeScreen(
                email: userEmail,
                name: Name,
                mobile_no: mobileNo,
                id_no: idNo,
              ),
            ),
          );
        } else if (userType == 'UserType.staff') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StaffHomeScreen(
                staff_name: Name,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.blueGrey,
              content: Text(
                'User with $userType not found for that email',
                style: const TextStyle(fontSize: 18.0, color: Colors.amber),
              ),
            ),
          );
        }
      }
    }

    void userLogin() async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email!,
          password: password!,
        );
        fetchData(email!);
      } on FirebaseAuthException catch (error) {
        if (error.code == 'user-not-found') {
          print('No User Found For that email');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.blueGrey,
              content: Text(
                'No User Found For that email. Please check your email or sign up.',
                style: TextStyle(fontSize: 18.0, color: Colors.amber),
              ),
            ),
          );
        } else if (error.code == 'wrong-password') {
          print('Wrong password provided by the user');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.blueGrey,
              content: Text(
                'Incorrect password. Please try again.',
                style: TextStyle(fontSize: 18.0, color: Colors.red),
              ),
            ),
          );
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 44, horizontal: 15),
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage('assets/images/login.jpg'),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  autofocus: false,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(fontSize: 15),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter email';
                    } else if (!value.contains('@')) {
                      return "please enter 'Valid Email'";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    email = value!;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  autofocus: false,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(fontSize: 15),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value!;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() {
                            email = emailController.text;
                            password = passwordController.text;
                          });
                          userLogin();
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgetPassword(),
                          ),
                        );
                      },
                      child: const Text(
                        'Forget password',
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
                  const Text('New here?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, a, b) => const SignUp(),
                          transitionDuration: const Duration(seconds: 0),
                        ),
                      );
                    },
                    child: const Text(
                      'Create an account',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
