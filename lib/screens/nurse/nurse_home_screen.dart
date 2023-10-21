// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:happycare/screens/nurse/patient_profile_screen.dart';

class NurseHomeScreen extends StatelessWidget {
  final String email;
  final String name;
  final String id_no;
  final String mobile_no;
  const NurseHomeScreen(
      {super.key,
      required this.email,
      required this.name,
      required this.id_no,
      required this.mobile_no});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9900),
        title: Text(
          'Nurse: $name',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Assigned Patients:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 5,
            ),
            Patient_List(
              patient_name: 'ABC',
              nurse_name: name,
            ),
            const SizedBox(
              height: 5,
            ),
            Patient_List(
              patient_name: 'ABC',
              nurse_name: name,
            ),
            const SizedBox(
              height: 5,
            ),
            Patient_List(
              patient_name: 'ABC',
              nurse_name: name,
            ),
            const SizedBox(
              height: 5,
            ),
            Patient_List(
              patient_name: 'ABC',
              nurse_name: name,
            ),
            const SizedBox(
              height: 5,
            ),
            Patient_List(
              patient_name: 'ABC',
              nurse_name: name,
            ),
            const SizedBox(
              height: 5,
            ),
            Patient_List(
              patient_name: 'ABC',
              nurse_name: name,
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class Patient_List extends StatelessWidget {
  final String patient_name;
  final String nurse_name;
  const Patient_List({
    super.key,
    required this.patient_name,
    required this.nurse_name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Color(0xFFFFF389),
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 35,
            width: 35,
            child: Image.asset('assets/images/child.png'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PatientProfileScreen(
                            name: patient_name,
                            nurse_assigned: nurse_name,
                          )));
            },
            child: Text(
              patient_name,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
