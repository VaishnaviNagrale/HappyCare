import 'package:flutter/material.dart';
import 'package:happycare/dbHelper/mongodb.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class PatientHomeScreen extends StatelessWidget {
  final String patientName;
  const PatientHomeScreen({super.key, required this.patientName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF9900),
        title: Text(
          '$patientName Details',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                        Text('${patientName}'),
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
                        Text('${data!['doctorName']}'),
                      ],
                    ),
                    const SizedBox(
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
                    // Text('Mobile Number: ${data['mobileNo']}'),
                    // Text('Adhar Number: ${data['adharNo']}'),
                    // Text('Address: ${data['address']}'),
                    // Text(
                    //     'Date Time When Registered: ${data['datePatientRegistered']}'),
                    // Text(
                    //     'Date Time When Doctor Assigned: ${data['dateDoctorAssigned']}'),
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
                          '${data['dateNurseAssigned']}',
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
    );
  }

  Future<Map<String, dynamic>> fetchData() async {
    final db = MongoDatabase.getDatabase();
    try {
      final nurseData = await db
          .collection('patient_assign_to_nurse')
          .findOne(mongo.where.eq('patientName', patientName));

      final doctorData = await db
          .collection('patient_assign_to_doctor')
          .findOne(mongo.where.eq('patientName', patientName));

      final patientsData = await db
          .collection('patients')
          .findOne(mongo.where.eq('name', patientName));

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
