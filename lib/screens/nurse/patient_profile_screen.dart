// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class PatientProfileScreen extends StatefulWidget {
  final String name;
  final String nurse_assigned;

  const PatientProfileScreen({
    Key? key,
    required this.name,
    required this.nurse_assigned,
  }) : super(key: key);

  @override
  _PatientProfileScreenState createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
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
    return Scaffold(
      //backgroundColor: const Color(0xFFB9D3FF),
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9900),
        title: Text(
          'Patient Name: ${widget.name}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'About :',
              style: TextStyle(
                  color: Color(0xFF023259),
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Text(
                      'Nurse Assigned: ${widget.nurse_assigned}',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'Date Admitted: 05/01/2023',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'Disease: Tuberculosis (TB)',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Tests :',
              style: TextStyle(
                  color: Color(0xFF023259),
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    _buildTestDetails(
                      'Blood Test: $bloodTest',
                      (value) => bloodTest = value,
                    ),
                    _buildTestDetails(
                      'Sugar Test: $sugarTest',
                      (value) => sugarTest = value,
                    ),
                    _buildTestDetails(
                      'BP Test: $bpTest',
                      (value) => bpTest = value,
                    ),
                    _buildTestDetails(
                      'Temperature: $temperature°C',
                      (value) => temperature = value,
                    ),
                    _buildTestDetails(
                      'ECG: $ecgTest',
                      (value) => ecgTest = value,
                    ),
                    _buildTestDetails(
                      'X-ray: $xRayTest',
                      (value) => xRayTest = value,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Medicines :',
              style: TextStyle(
                  color: Color(0xFF023259),
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    _buildMedicineInput(
                      'Morning Medicine: $morningMedicine',
                      (value) => morningMedicine = value,
                    ),
                    _buildMedicineInput(
                      'Evening Medicine: $eveningMedicine',
                      (value) => eveningMedicine = value,
                    ),
                    _buildMedicineInput(
                      'Night Medicine: $nightMedicine',
                      (value) => nightMedicine = value,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0xFF044B06)),
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
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestDetails(String labelText, Function(String) onChanged) {
    return ListTile(
      title: TextFormField(
        initialValue: labelText,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildMedicineInput(String labelText, Function(String) onChanged) {
    return ListTile(
      title: TextFormField(
        initialValue: labelText,
        onChanged: onChanged,
      ),
    );
  }
}
