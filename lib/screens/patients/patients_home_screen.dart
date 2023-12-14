// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:happycare/auth/signin_page.dart';
import 'package:happycare/dbHelper/mongodb.dart';
import 'package:happycare/screens/doctor/medicine.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class PatientHomeScreen extends StatefulWidget {
  final String patientName;
  const PatientHomeScreen({super.key, required this.patientName});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
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
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            hoverColor: Colors.black,
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()));
            },
          ),
        ],
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
                            Text(widget.patientName),
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
                        Row(
                          children: [
                            const Text(
                              'Doctor Assigned Name: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF07187A)),
                            ),
                            Text('${data['doctorName']}'),
                          ],
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
                        const SizedBox(
                          height: 4,
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
                        const SizedBox(
                          height: 4,
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
                              'Date Time When Assigned To Doctor: ',
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
                        const SizedBox(
                          height: 4,
                        ),
                        Column(
                          children: [
                            const Text(
                              'Date Time When Assigned To Nurse: ',
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
                          height: 4,
                        ),
                        Column(
                          children: [
                            const Text(
                              'Date Time When Registered: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF07187A),
                              ),
                            ),
                            Text(
                              '${data['datePatientRegistered']}',
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
          const SizedBox(height: 5),
          const Text(
            'Medicines Prescribed',
            style: TextStyle(
              color: Colors.blue, // Professional color
              decoration: TextDecoration.underline,
              decorationThickness: 2,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          FutureBuilder<List<Medicine>>(
            future: fetchMedicineData(widget.patientName),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No data found'));
              } else {
                List<Medicine>? data = snapshot.data;
                return Expanded(
                  child: ListView.builder(
                    itemCount: data!.length,
                    itemBuilder: (context, index) {
                      final medicine = data[index];
                      // print(medicine.name);
                      return Medicine_List(
                        medicine_name: medicine.name,
                        quantity: medicine.quantity,
                        noDays: medicine.noDays,
                      );
                    },
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'Tests Prescribed',
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
                return Expanded(
                  // Provide proper constraints using Expanded
                  child: ListView.builder(
                    itemCount: data!.length,
                    itemBuilder: (context, index) {
                      return Tests_List(
                        test_name: data[index],
                        date_time: data[index], // Replace with relevant data
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<List<Medicine>> fetchMedicineData(String patient_name) async {
    final db = MongoDatabase.getDatabase();
    final cursor = db.collection('MedicinePrescribedByDoctor').find(
          mongo.where.eq('patient name', patient_name),
        );

    final List<Medicine> medicines = [];

    await for (var data in cursor) {
      final medicinename = data['medicine name'];
      final quantity = data['quantitiy'];
      final noDays = data['no days'];

      final medicine = Medicine(
        name: medicinename,
        quantity: quantity,
        noDays: noDays,
      );
      print(medicine);
      medicines.add(medicine);
    }

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
          color: const Color(0xFFFFF389),
          border: Border.all(
            width: 2,
            color: Colors.black,
          )),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
          tileColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.grey[300]!),
          ),
          title: Row(
            children: [
              const Text(
                'Medicine Name :',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                ' $medicine_name',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Quantity :',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' $quantity',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Days to Take :',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' $noDays',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
          color: const Color(0xFFFFF389),
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
          ],
        ),
      ),
    );
  }
}
