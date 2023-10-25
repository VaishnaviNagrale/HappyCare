// ignore_for_file: non_constant_identifier_names, camel_case_types, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happycare/dbHelper/mongodb.dart';
import 'package:happycare/screens/staff/assign_nurse/assign_nurse_screen.dart';
import 'package:happycare/screens/staff/staff_home_screen.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AssignDoctorToPatientScreen extends StatelessWidget {
  final String selected_disease_name;
  final String staff_name;
  final String patient_name;
  const AssignDoctorToPatientScreen(
      {super.key,
      required this.selected_disease_name,
      required this.staff_name,
      required this.patient_name});

  @override
  Widget build(BuildContext context) {
    Future<List<String>> fetchData(String selected_disease_name) async {
      final db = MongoDatabase.getDatabase();
      final userData = await db
          .collection('users')
          .find(where.eq('speciality', selected_disease_name))
          .toList();

      if (userData != null) {
        List<String> doctors = [];

        for (var data in userData) {
          final doctorname = data['name'];
          doctors.add(doctorname);
        }
        return doctors;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.blueGrey,
            content: Text(
              'Doctor for $selected_disease_name not found',
              style: const TextStyle(fontSize: 18.0, color: Colors.amber),
            ),
          ),
        );
        return [];
      }
    }

    return FutureBuilder<List<String>>(
        future: fetchData(selected_disease_name),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Display a loading indicator.
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No doctors available for this disease.');
          } else {
            List<String>? available_doctors = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xFFFF9900),
                title: Text(
                  'Doctors For $selected_disease_name Disease',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
              ),
              body: ListView.builder(
                itemCount: available_doctors!.length,
                itemBuilder: (context, index) {
                  return Doctor_List(
                    doctor_name: available_doctors[index],
                    staff_name: staff_name,
                    patient_name: patient_name,
                    selected_disease_name: selected_disease_name,
                  );
                },
              ),
            );
          }
        });
  }
}

class Doctor_List extends StatelessWidget {
  final String doctor_name;
  final String staff_name;
  final String patient_name;
  final String selected_disease_name;
  const Doctor_List({
    super.key,
    required this.doctor_name,
    required this.staff_name,
    required this.patient_name,
    required this.selected_disease_name,
  });

  @override
  Widget build(BuildContext context) {
    void assignDoctorToPatient(String doctorName) async {
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
            await db.collection('patient_assign_to_doctor').insertOne({
          'doctorName': doctorName,
          'patientName': patient_name,
          'diseaseName': selected_disease_name,
          'staffName': staff_name,
          'date-time': DateTime.now(),
        });

        if (mongoResult == null) {
          // Handle MongoDB insertion error
          print('Error: MongoDB data insertion failed');
          return;
        }
        // Update Firestore with assignment information
        await firestore.collection('patient_assign_to_doctor').add(
          {
            'doctorName': doctorName,
            'patientName': patient_name,
            'diseaseName': selected_disease_name,
            'staffName': staff_name,
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Doctor assigned successfully!',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AssignNurseToPatientScreen(
                staff_name: staff_name, patient_name: patient_name),
          ),
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
                  'Assign Doctor',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                content: Text(
                  'Are you sure you want to assign $patient_name to $doctor_name?',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      assignDoctorToPatient(doctor_name);
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
          doctor_name,
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
