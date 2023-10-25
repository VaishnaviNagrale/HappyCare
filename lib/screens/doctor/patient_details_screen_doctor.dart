// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happycare/dbHelper/mongodb.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class PatientDetailsScreenNurse extends StatefulWidget {
  final String patientName;
  PatientDetailsScreenNurse({super.key, required this.patientName});

  @override
  State<PatientDetailsScreenNurse> createState() => _PatientDetailsScreenNurseState();
}

class _PatientDetailsScreenNurseState extends State<PatientDetailsScreenNurse> {
  String morningMedicine = '';

  String eveningMedicine = '';

  String nightMedicine = '';

  String bloodTest = '';

  String sugarTest = '';

  String bpTest = '';

  String temperature = '';

  String ecgTest = '';

  String xRayTest = '';

  @override
  Widget build(BuildContext context) {
    void PatientReportUpdatesByNurse() async {
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
            await db.collection('PatientReportUpdatesByNurse').insertOne({
          'patient name': widget.patientName,
          'blood test': bloodTest,
          'sugar test': sugarTest,
          'BP test': bpTest,
          'temperature': temperature,
          'ECG test': ecgTest,
          'X-ray': xRayTest,
          'morning medicine': morningMedicine,
          'evening medicine': eveningMedicine,
          'night medicine': nightMedicine,
          'date-time': DateTime.now(),
        });

        if (mongoResult == null) {
          // Handle MongoDB insertion error
          print('Error: MongoDB data insertion failed');
          return;
        }
        // Add user data to Firestore
        await firestore.collection('PatientReportUpdatesByNurse').add(
          {
            'patient name': widget.patientName,
            'blood test': bloodTest,
            'sugar test': sugarTest,
            'BP test': bpTest,
            'temperature': temperature,
            'ECG test': ecgTest,
            'X-ray': xRayTest,
            'morning medicine': morningMedicine,
            'evening medicine': eveningMedicine,
            'night medicine': nightMedicine,
            'date-time': DateTime.now(),
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.blueGrey,
            content: Text(
              'Registration Successful',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
        );
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF9900),
        title: Text(
          '${widget.patientName} Details',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            final data = snapshot.data;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Patient Name: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF07187A)),
                        ),
                        Text('${widget.patientName}'),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Text(
                          'Disease Name: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF07187A)),
                        ),
                        Text('${data!['diseaseType']}'),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Text(
                          'Doctor Assigned Name: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF07187A)),
                        ),
                        Text('${data!['doctorName']}'),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    // Row(
                    //   children: [
                    //     Text(
                    //       'Nurse Assigned Name: ',
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 14,
                    //           color: Color(0xFF07187A)),
                    //     ),
                    //     Text('${data!['nurseName']}'),
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     Text(
                    //       'Staff That Registered Name: ',
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 14,
                    //           color: Color(0xFF07187A)),
                    //     ),
                    //     Text('${data['staffAssigned']}'),
                    //   ],
                    // ),
                    Row(
                      children: [
                        Text(
                          'Age: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF07187A)),
                        ),
                        Text('${data['age']}'),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Text(
                          'Gender: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF07187A)),
                        ),
                        Text('${data['gender']}'),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    // Text('Mobile Number: ${data['mobileNo']}'),
                    // Text('Adhar Number: ${data['adharNo']}'),
                    // Text('Address: ${data['address']}'),
                    // Text(
                    //     'Date Time When Registered: ${data['datePatientRegistered']}'),
                    // Text(
                    //     'Date Time When Doctor Assigned: ${data['dateDoctorAssigned']}'),
                    Column(
                      children: [
                        Text(
                          'Date Time When Assigned To You: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF07187A),
                          ),
                        ),
                        Text(
                          '${data['dateNurseAssigned']}',
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    Column(
                      children: [
                        const Text(
                          'Tests',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            decorationThickness: 2,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          elevation: 3, // Add a slight shadow for a card effect
                          margin: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              _buildTestItem("Blood Test", bloodTest,
                                  (value) => bloodTest = value),
                              _buildTestItem("Sugar Test", sugarTest,
                                  (value) => sugarTest = value),
                              _buildTestItem(
                                  "BP Test", bpTest, (value) => bpTest = value),
                              _buildTestItem("Temperature (°C)", temperature,
                                  (value) => temperature = value),
                              _buildTestItem(
                                  "ECG", ecgTest, (value) => ecgTest = value),
                              _buildTestItem("X-ray", xRayTest,
                                  (value) => xRayTest = value),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Medicines :',
                          style: TextStyle(
                            color: Colors.blue, // Professional color
                            decoration: TextDecoration.underline,
                            decorationThickness: 2,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          elevation: 3, // Add a slight shadow for a card effect
                          margin: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              _buildMedicineItem(
                                  "Morning Medicine",
                                  morningMedicine,
                                  (value) => morningMedicine = value),
                              _buildMedicineItem(
                                  "Evening Medicine",
                                  eveningMedicine,
                                  (value) => eveningMedicine = value),
                              _buildMedicineItem(
                                  "Night Medicine",
                                  nightMedicine,
                                  (value) => nightMedicine = value),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF044B06)),
                          onPressed: () {
                            // Save or update the data in Firestore with the new values.
                            // You can use Firebase or another database to store this data.
                            // For simplicity, we're just printing the updated values here.
                            print('Morning Medicine: $morningMedicine');
                            print('Evening Medicine: $eveningMedicine');
                            print('Night Medicine: $nightMedicine');
                            print('Blood Test: $bloodTest');
                            print('Sugar Test: $sugarTest');
                            print('BP Test: $bpTest');
                            print('Temperature: $temperature°C');
                            print('ECG: $ecgTest');
                            print('X-ray: $xRayTest');
                            PatientReportUpdatesByNurse();
                            setState(() {
                              morningMedicine = '';
                              eveningMedicine = '';
                              nightMedicine = '';
                              bloodTest = '';
                              sugarTest = '';
                              bpTest = '';
                              temperature = '';
                              ecgTest = '';
                              xRayTest = '';
                            });
                          },
                          child: const Text('Save Changes'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> fetchData() async {
    final db = MongoDatabase.getDatabase();
    try {
      final nurseData = await db
          .collection('patient_assign_to_nurse')
          .findOne(mongo.where.eq('patientName', widget.patientName));

      final doctorData = await db
          .collection('patient_assign_to_doctor')
          .findOne(mongo.where.eq('patientName', widget.patientName));

      final patientsData = await db
          .collection('patients')
          .findOne(mongo.where.eq('name', widget.patientName));

      print('Nurse Data: $nurseData');
      print('Doctor Data: $doctorData');
      print('Patients Data: $patientsData');

      if (nurseData != null && doctorData != null && patientsData != null) {
        return {
          'nurseName': nurseData['nurseName'],
          'doctorName': doctorData['doctorName'],
          'dateNurseAssigned': nurseData['date-time'],
          'dateDoctorAssigned': doctorData['date-time'],
          'diseaseType': doctorData['diseaseName'],
          'staffAssigned': nurseData['staffName'],
          'mobileNo': patientsData['mobileNo'],
          'adharNo': patientsData['adharNo'],
          'address': patientsData['address'],
          'age': patientsData['age'],
          'gender': patientsData['gender'] == true ? 'Male' : 'Female',
          'datePatientRegistered': patientsData['date-time'],
        };
      } else {
        return {};
      }
    } catch (e) {
      print('Error fetching data: $e');
      return {};
    }
  }
}

Widget _buildTestItem(String label, String value, Function(String) onChanged) {
  return ListTile(
    title: TextFormField(
      initialValue: value,
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label),
    ),
  );
}

Widget _buildMedicineItem(
    String label, String value, Function(String) onChanged) {
  return ListTile(
    title: TextFormField(
      initialValue: value,
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label),
    ),
  );
}
