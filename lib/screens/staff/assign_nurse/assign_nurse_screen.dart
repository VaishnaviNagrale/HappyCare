// ignore_for_file: non_constant_identifier_names, camel_case_types, use_build_context_synchronously, unnecessary_null_comparison
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happycare/dbHelper/mongodb.dart';
import 'package:happycare/screens/staff/staff_home_screen.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AssignNurseToPatientScreen extends StatelessWidget {
  final String staff_name;
  final String patient_name;
  const AssignNurseToPatientScreen(
      {super.key, required this.staff_name, required this.patient_name});

  @override
  Widget build(BuildContext context) {
    Future<List<String>> fetchData(String UserType) async {
      final db = MongoDatabase.getDatabase();
      final userData = await db
          .collection('users')
          .find(where.eq('userType', UserType))
          .toList();

      if (userData != null) {
        List<String> nurses = [];

        for (var data in userData) {
          final nursename = data['name'];
          nurses.add(nursename);
        }
        return nurses;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.blueGrey,
            content: Text(
              'Nurses are not avaliable',
              style: TextStyle(fontSize: 18.0, color: Colors.amber),
            ),
          ),
        );
        return [];
      }
    }

    return FutureBuilder<List<String>>(
        future: fetchData('UserType.nurse'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Display a loading indicator.
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No nurse available.');
          } else {
            List<String>? available_nurses = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xFFFF9900),
                title: const Text(
                  'Nurses Avaliable',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
              ),
              body: ListView.builder(
                itemCount: available_nurses!.length,
                itemBuilder: (context, index) {
                  return Nurse_List(
                    nurse_name: available_nurses[index],
                    staff_name: staff_name,
                    patient_name: patient_name,
                  );
                },
              ),
            );
          }
        });
  }
}

class Nurse_List extends StatelessWidget {
  final String nurse_name;
  final String staff_name;
  final String patient_name;
  const Nurse_List({
    super.key,
    required this.nurse_name,
    required this.staff_name,
    required this.patient_name,
  });

  @override
  Widget build(BuildContext context) {
    void assignNurseToPatient(String nurseName) async {
      try {
        final firestore = FirebaseFirestore.instance;
        final db = MongoDatabase.getDatabase();
        if (db == null) {
          // Handle MongoDB connection error
          print('Error: MongoDB connection failed');
          return;
        }

        // Insert data into MongoDB
        final mongoResult =
            await db.collection('patient_assign_to_nurse').insertOne({
          'nurseName': nurseName,
          'patientName': patient_name,
          'staffName': staff_name,
          'date-time': DateTime.now(),
        });

        if (mongoResult == null) {
          // Handle MongoDB insertion error
          print('Error: MongoDB data insertion failed');
          return;
        }
        // Update Firestore with assignment information
        await firestore.collection('patient_assign_to_nurse').add(
          {
            'nurseName': nurseName,
            'patientName': patient_name,
            'staffName': staff_name,
            'date-time': DateTime.now(),
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Nurse assigned successfully!',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => StaffHomeScreen(staff_name: staff_name)),
        );
      } catch (e) {
        print(e);
      }
    }

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
          // Display an AlertDialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'Assign Nurse',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                content: Text(
                  'Are you sure you want to assign $patient_name to nurse $nurse_name?',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      assignNurseToPatient(nurse_name);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StaffHomeScreen(
                            staff_name: staff_name,
                          ),
                        ),
                      ); // Close the dialog
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.green,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text(
                      'No',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Text(
          nurse_name,
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
