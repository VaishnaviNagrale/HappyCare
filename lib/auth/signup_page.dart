import 'package:flutter/material.dart';
import 'package:happycare/auth/email/doctor_signup.dart';
import 'package:happycare/auth/signin_page.dart';
import 'package:happycare/auth/email/email_pass_signup.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/swastyaseva-logo.jpg',
              height: 100,
              width: 100,
            ),
            SizedBox(
              width: 20,
            ),
            const Text(
              'Create an account',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(
          height: 50.0,
        ),
        Container(
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              border: Border.all(
            width: 2,
            color: Colors.black,
          )),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset('assets/images/doctor.png'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DoctorEmailPassSignUp(),
                      ),
                    );
                  },
                  child: const Text(
                    'Sign up as Doctor',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              border: Border.all(
            width: 2,
            color: Colors.black,
          )),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset('assets/images/nurse.png'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmailPassSignUp(),
                      ),
                    );
                  },
                  child: const Text(
                    'Sign up as Nurse',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              border: Border.all(
            width: 2,
            color: Colors.black,
          )),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset('assets/images/receptionist.png'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmailPassSignUp(),
                      ),
                    );
                  },
                  child: const Text(
                    'Sign up as Staff',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Have an account?'),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, a, b) => const SignInScreen(),
                      transitionDuration: const Duration(seconds: 0),
                    ),
                  );
                },
                child: const Text(
                  'Sign In',
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
