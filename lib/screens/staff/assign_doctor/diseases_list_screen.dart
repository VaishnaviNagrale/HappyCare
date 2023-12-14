// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:happycare/screens/staff/assign_doctor/assign_doctor_screen.dart';

class DisaesesListScreen extends StatelessWidget {
  final String staff_name;
  final String patient_name;
  const DisaesesListScreen(
      {super.key, required this.staff_name, required this.patient_name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF9900),
        title: const Text(
          'Select Disease',
          style: TextStyle(
            // fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(children: [
        Disease_List(
          disease_name: 'Brain',
          staff_name: staff_name,
          patient_name: patient_name,
        ),
        Disease_List(
          disease_name: 'Heart',
          staff_name: staff_name,
          patient_name: patient_name,
        ),
        Disease_List(
          disease_name: 'Eyes',
          staff_name: staff_name,
          patient_name: patient_name,
        ),
        Disease_List(
          disease_name: 'Ears',
          staff_name: staff_name,
          patient_name: patient_name,
        ),
        Disease_List(
          disease_name: 'Throat',
          staff_name: staff_name,
          patient_name: patient_name,
        ),
        Disease_List(
          disease_name: 'Lungs',
          staff_name: staff_name,
          patient_name: patient_name,
        ),
        Disease_List(
          disease_name: 'Stomach',
          staff_name: staff_name,
          patient_name: patient_name,
        ),
        Disease_List(
          disease_name: 'Legs',
          staff_name: staff_name,
          patient_name: patient_name,
        ),
        Disease_List(
          disease_name: 'Diabetes',
          staff_name: staff_name,
          patient_name: patient_name,
        ),
        Disease_List(
          disease_name: 'Kidney',
          staff_name: staff_name,
          patient_name: patient_name,
        ),
        Disease_List(
          disease_name: 'Psychiatrist',
          staff_name: staff_name,
          patient_name: patient_name,
        ),
      ]),
    );
  }
}

class Disease_List extends StatelessWidget {
  final String disease_name;
  final String staff_name;
  final String patient_name;
  const Disease_List({
    super.key,
    required this.disease_name,
    required this.staff_name,
    required this.patient_name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFECB3),
        border: Border.all(
          width: 1,
          color: Colors.blue,
        ),
      ),
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AssignDoctorToPatientScreen(
                selected_disease_name: disease_name,
                patient_name: patient_name,
                staff_name: staff_name,
              ),
            ),
          );
        },
        child: Text(
          disease_name,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
