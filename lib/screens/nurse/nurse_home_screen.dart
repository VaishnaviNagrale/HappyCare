// ignore_for_file: non_constant_identifier_names, camel_case_types, use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:happycare/auth/signin_page.dart';
import 'package:happycare/dbHelper/mongodb.dart';
import 'package:happycare/screens/nurse/patient_details_screen_nurse.dart';
import 'package:mongo_dart/mongo_dart.dart';

class NurseHomeScreen extends StatelessWidget {
  final String userEmail;
  const NurseHomeScreen({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    Future<List<String>> fetchPatientData(String nurse_name) async {
      // final firestore = FirebaseFirestore.instance;
      // final QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
      //     .collection('patient_assign_to_nurse')
      //     .where('nurseName', isEqualTo: nurse_name)
      //     .get();
      final db = MongoDatabase.getDatabase();
      final userData = await db
          .collection('patient_assign_to_nurse')
          .find(where.eq('nurseName', nurse_name))
          .toList();

      if (userData != null) {
        List<String> patients = [];

        for (var data in userData) {
          final patientname = data['patientName'];
          patients.add(patientname);
        }

        return patients;
      } else {
        // No patients assigned to the doctor
        return [];
      }
    }

    Future<List<String>> fetchNurseData() async {
      //final firestore = FirebaseFirestore.instance;
      final db = await MongoDatabase
          .getDatabase(); // Replace this with your MongoDB connection setup.

      final userData =
          await db.collection('users').findOne(where.eq('email', userEmail));

      if (userData != null) {
        final nurseName = userData['name'];
        // final QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        //     .collection('users')
        //     .where('email', isEqualTo: userEmail)
        //     .get();

        // if (querySnapshot.docs.isNotEmpty) {
        //   final userData = querySnapshot.docs.first.data();
        //   final nurse_name = userData['name'];

        // Now you can check the userType and take appropriate actions.
        try {
          return fetchPatientData(nurseName);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.amber,
              content: Text(
                'User with $nurseName not found for that email',
                style: const TextStyle(fontSize: 18.0, color: Colors.white,),
              ),
            ),
          );
        }
      }
      return [''];
    }

    return FutureBuilder<List<String>>(
        future: fetchNurseData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Display a loading indicator.
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No patient assigned yet.');
          } else {
            List<String>? patients = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xFFFF9900),
                title: const Text(
                  'Patients Assigned To Nurse',
                  style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  maxLines: 2,
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    hoverColor: Colors.black,
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()));
                    },
                  ),
                ],
              ),
              body: ListView.builder(
                itemCount: patients!.length,
                itemBuilder: (context, index) {
                  return Patient_List(
                    patient_name: patients[index],
                  );
                },
              ),
            );
          }
        });
  }
}

class Patient_List extends StatelessWidget {
  final String patient_name;
  const Patient_List({
    super.key,
    required this.patient_name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: const Color(0xFFFFF389),
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
              child: Image.asset('assets/images/child.png'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PatientDetailsScreenNurse(patientName: patient_name),
                  ),
                );
              },
              child: Text(
                patient_name,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
