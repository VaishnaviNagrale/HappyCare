// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happycare/auth/email/email_pass_login.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final uID = FirebaseAuth.instance.currentUser!.uid;
  final email = FirebaseAuth.instance.currentUser!.email;
  final creationTime = FirebaseAuth.instance.currentUser!.metadata.creationTime;

  User? user = FirebaseAuth.instance.currentUser;

  VerifyEmail() async {
    if (user != null && !user!.emailVerified) {
      await user!.sendEmailVerification();
      print('Verification email has been sent');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.black38,
          content: Text(
            'Verification email has been sent',
            style: TextStyle(fontSize: 15.0, color: Colors.amber),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset('assets/images/profile.png'),
              ),
              const SizedBox(
                height: 50.0,
              ),
              Column(
                children: [
                  const Text(
                    'User ID: ',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    uID,
                    style:
                        const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              const SizedBox(
                height: 30.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Email: ',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    email.toString(),
                    style:
                        const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),
                  ),
                  user!.emailVerified
                      ? const Text(
                          'Verified',
                          style: TextStyle(fontSize: 18.0, color: Colors.green),
                        )
                      : TextButton(
                          onPressed: () {
                            VerifyEmail();
                          },
                          child: const Text(
                            'Verify Email',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.lightBlue,
                            ),
                          ),
                        ),
                ],
              ),
              const SizedBox(
                height: 30.0,
              ),
              Column(
                children: [
                  const Text(
                    'Created: ',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    creationTime.toString(),
                    style:
                        const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmailPassLoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}