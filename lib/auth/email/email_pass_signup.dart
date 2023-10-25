// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, use_build_context_synchronously, unnecessary_null_comparison
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happycare/auth/signin_page.dart';
import 'package:happycare/auth/email/email_pass_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:happycare/dbHelper/mongodb.dart';

class EmailPassSignUp extends StatefulWidget {
  const EmailPassSignUp({Key? key}) : super(key: key);

  @override
  State<EmailPassSignUp> createState() => _EmailPassSignUpState();
}

enum UserType { doctor, nurse, staff }

class _EmailPassSignUpState extends State<EmailPassSignUp> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String confromPass = '';
  String name = '';
  String mobile_no = '';
  String id_no = '';
  String hospital_name = '';
  UserType userType = UserType.doctor;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    conformpassController.dispose();
    super.dispose();
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conformpassController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobilenoController = TextEditingController();
  TextEditingController idnoController = TextEditingController();
  TextEditingController hospitalnameController = TextEditingController();

  Registration() async {
    if (password == confromPass) {
      try {
        UserCredential userCredentials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        final firestore = FirebaseFirestore.instance;
        final db = MongoDatabase.getDatabase();

      if (db == null) {
        // Handle MongoDB connection error
        print('Error: MongoDB connection failed');
        return;
      }

      // Insert data into MongoDB
      final mongoResult = await db.collection('users').insertOne({
        'name': name,
        'email': email,
        'userType': userType.toString(),
        'mobileNo': mobile_no,
        'idNo': id_no,
        'hospitalName': hospital_name,
      });

      if (mongoResult == null) {
        // Handle MongoDB insertion error
        print('Error: MongoDB data insertion failed');
        return;
      }

        // Add user data to Firestore
        await firestore.collection('users').add({
          'name': name,
          'email': email,
          'userType': userType.toString(),
          'mobileNo': mobile_no,
          'idNo': id_no,
          'hospitalName': hospital_name,
        });

        print(userCredentials);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.blueGrey,
            content: Text(
              'Registration Successfully, Please Sign In',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmailPassLoginScreen(),
          ),
        );
      } on FirebaseAuthException catch (error) {
        if (error.code == 'weak-password') {
          print('Password is too weak');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.black26,
              content: Text(
                'Password is too weak',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.amberAccent,
                ),
              ),
            ),
          );
        } else if (error.code == 'email-already-in-use') {
          print('Account is already exits');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.black26,
              content: Text(
                'Account is already exits',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.amber,
                ),
              ),
            ),
          );
        } else {
          print(error);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.black26,
              content: Text(
                'Password and Conform Password does not matched',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.red,
                ),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.blue,
          ),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => SignInScreen()));
          },
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Image(
                  height: 250,
                  width: 250,
                  image: AssetImage('assets/images/swastyaseva-logo.jpg'),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  autofocus: false,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: TextStyle(fontSize: 15),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter full name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    name = value!;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: DropdownButtonFormField<UserType>(
                  value: userType,
                  onChanged: (value) {
                    setState(() {
                      userType = value!;
                    });
                  },
                  items: UserType.values.map((type) {
                    return DropdownMenuItem<UserType>(
                      value: type,
                      child: Text(type.toString().split('.').last),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'User Type',
                    labelStyle: TextStyle(fontSize: 15),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
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
                  decoration: const InputDecoration(
                    labelText: 'Mobile No',
                    labelStyle: TextStyle(fontSize: 15),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  controller: mobilenoController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter mobile no';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    mobile_no = value!;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  autofocus: false,
                  decoration: const InputDecoration(
                    labelText: 'ID No',
                    labelStyle: TextStyle(fontSize: 15),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  controller: idnoController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter id no';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    id_no = value!;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  autofocus: false,
                  decoration: const InputDecoration(
                    labelText: 'Hospital Name',
                    labelStyle: TextStyle(fontSize: 15),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  controller: hospitalnameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter hospital name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    hospital_name = value!;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: TextFormField(
                  autofocus: false,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Password (8+ characters)',
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
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  autofocus: false,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Conform Password',
                    hintText: 'Password (8+ characters)',
                    labelStyle: TextStyle(fontSize: 15),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  controller: conformpassController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter password again';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    confromPass = value!;
                  },
                ),
              ),
              const SizedBox(
                height: 15.0,
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
                            confromPass = conformpassController.text;
                          });
                          Registration();
                        }
                      },
                      child: const Text(
                        'SignUp',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account ?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                const SignInScreen(),
                            transitionDuration: const Duration(seconds: 0),
                          ),
                        );
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
