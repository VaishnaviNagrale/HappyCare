// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:happycare/dbHelper/mongodb.dart';
import 'package:happycare/screens/patients/patients_home_screen.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class PatientLoginScreen extends StatefulWidget {
  const PatientLoginScreen({Key? key}) : super(key: key);

  @override
  State<PatientLoginScreen> createState() => _PatientLoginScreenState();
}

class _PatientLoginScreenState extends State<PatientLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? name;
  String? mobileno;
  TextEditingController nameController = TextEditingController();
  TextEditingController mobilenoController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    mobilenoController.dispose();
    super.dispose();
  }

  Future<void> fetchData(String userName, String userNo) async {
    final db = MongoDatabase.getDatabase();
    final patientsData = await db
        .collection('patients')
        .findOne(mongo.where.eq('name', userName));
    print('Patients Data: $patientsData');

    if (patientsData != null) {
      // Perform actions for a successful login
      // This could involve setting up the authentication flow or navigating to the next screen.
      String patientName = patientsData['name'];
      String patientNo = patientsData['mobileNo'];
      if (userName == patientName && userNo == patientNo) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Login Successful',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientHomeScreen(patientName: patientName),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.amber,
            content: Text(
              'Please check your credentials',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ),
        );
      }
    } else {
      // Handle case where user details are not found in the MongoDB collection
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.amber,
          content: Text(
            'User with name $userName not found',
            style: const TextStyle(fontSize: 18.0, color: Colors.white),
          ),
        ),
      );
    }
  }

  void userLogin() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        name = nameController.text;
        mobileno = mobilenoController.text;
      });
      fetchData(name!, mobileno!);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    labelText: 'Name',
                    labelStyle: TextStyle(fontSize: 15),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter your name';
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
                child: TextFormField(
                  autofocus: false,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mobile No',
                    labelStyle: TextStyle(fontSize: 15),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  controller: mobilenoController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mobile no';
                    } else if (value.length < 10) {
                      return 'Number must be of 10 digits';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    mobileno = value!;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: userLogin,
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
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
