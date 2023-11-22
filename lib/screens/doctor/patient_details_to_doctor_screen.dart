// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happycare/dbHelper/mongodb.dart';
import 'package:happycare/screens/doctor/prescribe_medicines.dart';
import 'package:happycare/screens/doctor/test_list_screen.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class PatientDetailsScreenDoctor extends StatefulWidget {
  final String patientName;
  const PatientDetailsScreenDoctor({super.key, required this.patientName});

  @override
  State<PatientDetailsScreenDoctor> createState() =>
      _PatientDetailsScreenDoctorState();
}

class _PatientDetailsScreenDoctorState
    extends State<PatientDetailsScreenDoctor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF9900),
        title: Text(
          '${widget.patientName} Details',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder<Map<String, dynamic>>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No data found'));
              } else {
                final data = snapshot.data;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Patient Name: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF07187A)),
                            ),
                            Text('${widget.patientName}'),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Disease Name: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF07187A)),
                            ),
                            Text('${data!['diseaseType']}'),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Nurse Assigned Name: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF07187A)),
                            ),
                            Text('${data['nurseName']}'),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Staff That Registered Name: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF07187A)),
                            ),
                            Text('${data['staffAssigned']}'),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Age: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF07187A)),
                            ),
                            Text('${data['age']}'),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Gender: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF07187A)),
                            ),
                            Text('${data['gender']}'),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Column(
                          children: [
                            const Text(
                              'Date Time When Assigned To You: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF07187A),
                              ),
                            ),
                            Text(
                              '${data['dateDoctorAssigned']}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
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
          FutureBuilder<List<String>>(
            future: fetchMedicineData(widget.patientName),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No data found'));
              } else {
                final data = snapshot.data;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: ListView.builder(
                      itemCount: data!.length,
                      itemBuilder: (context, index) {
                        return Medicine_List(
                          medicine_name: data[index],
                          quantity: data[index],
                          noDays: data[index],
                        );
                      },
                    ),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'Tests :',
            style: TextStyle(
              color: Colors.blue, // Professional color
              decoration: TextDecoration.underline,
              decorationThickness: 2,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          FutureBuilder<List<String>>(
            future: fetchTestsData(widget.patientName),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No data found'));
              } else {
                List<String>? data = snapshot.data;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: ListView.builder(
                      itemCount: data!.length,
                      itemBuilder: (context, index) {
                        return Tests_List(
                            test_name: data[index], date_time: data[index]);
                      },
                    ),
                  ),
                );
              }
            },
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrescribeMedicinesToPatient(
                            patient_name: widget.patientName)));
              },
              child: Text('Prescribe Medicine')),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrescribeTestsToPatient(
                            patient_name: widget.patientName)));
              },
              child: Text('    Prescribe Tests   ')),
        ],
      ),
    );
  }

  Future<List<String>> fetchMedicineData(String patient_name) async {
    final db = MongoDatabase.getDatabase();
    final cursor = db.collection('MedicinePrescribedByDoctor').find(
          mongo.where.eq('patient name', patient_name),
        );

    final List<String> medicines = [];

    await for (var data in cursor) {
      final medicinename = data['medicine name'];
      final quantity = data['quantity'];
      final noDays = data['no of days'];
      final dateTime = data['date-time'];
      medicines.add(medicinename);
      medicines.add(quantity);
      medicines.add(noDays);
      medicines.add(dateTime);
    }

    if (medicines.isEmpty) {
      // No medicines prescribed to patient yet
      return [];
    }
    print('medData: $medicines');
    return medicines;
  }

  Future<List<String>> fetchTestsData(String patient_name) async {
    final db = MongoDatabase.getDatabase();
    final cursor = db.collection('TestPrescribedByDoctor').find(
          mongo.where.eq('patient name', patient_name),
        );

    final List<String> tests = [];

    await for (var data in cursor) {
      final testName = data['test name'];
      tests.add(testName);
    }

    if (tests.isEmpty) {
      // No medicines prescribed to patient yet
      return [];
    }
    print('tests Data: $tests');
    return tests;
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

      // print('Nurse Data: $nurseData');
      // print('Doctor Data: $doctorData');
      // print('Patients Data: $patientsData');

      await fetchMedicineData(widget.patientName);
      await fetchTestsData(widget.patientName);

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

class Medicine_List extends StatelessWidget {
  final String medicine_name;
  final String quantity;
  final String noDays;
  const Medicine_List({
    super.key,
    required this.medicine_name,
    required this.quantity,
    required this.noDays,
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
          )),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(
            //   height: 50,
            //   width: 50,
            //   child: Image.asset('assets/images/child.png'),
            // ),
            Text(
              medicine_name,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600),
            ),
            Text(
              quantity,
              style: const TextStyle(color: Colors.black),
            ),
            Text(
              noDays,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class Tests_List extends StatelessWidget {
  final String test_name;
  final String date_time;
  const Tests_List({
    super.key,
    required this.test_name,
    required this.date_time,
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
          )),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              test_name,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600),
            ),
            Text(
              date_time,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
