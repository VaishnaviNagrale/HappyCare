// ignore_for_file: non_constant_identifier_names, camel_case_types, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happycare/screens/staff/staff_home_screen.dart';

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
      final firestore = FirebaseFirestore.instance;
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('users')
          .where('speciality', isEqualTo: selected_disease_name)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        final userType = userData['userType'];
        final speciality = userData['speciality'];
        final Name = userData['name'];

        // Now you can check the userType and take appropriate actions.
        if (userType == 'UserType.doctor' &&
            speciality == selected_disease_name) {
          return [Name];
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
      return [''];
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
                title: Text(
                  'Doctors For $selected_disease_name Disease',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StaffHomeScreen(
              staff_name: staff_name,
            ),
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
                  'Are you sure you want to assign $patient_name to this doctor: $doctor_name?',
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
