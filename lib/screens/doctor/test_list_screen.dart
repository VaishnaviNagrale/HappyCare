import 'package:flutter/material.dart';
import 'package:happycare/screens/doctor/prescribe_medicines.dart';

class TestListScreen extends StatelessWidget {
  final String patient_name;
  const TestListScreen({super.key, required this.patient_name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9900),
        title: Text(
          'Medical tests that should be assigned to $patient_name',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Tests_List(patient_name: patient_name, test_name: 'Blood Test'),
          Tests_List(patient_name: patient_name, test_name: 'Suger Test'),
          Tests_List(
              patient_name: patient_name, test_name: 'Blood Pressure Test'),
          Tests_List(patient_name: patient_name, test_name: 'X-ray'),
          Tests_List(patient_name: patient_name, test_name: 'ECG Test'),
          Tests_List(patient_name: patient_name, test_name: 'MRI Scan'),
          Tests_List(patient_name: patient_name, test_name: 'Blood Test'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0xFF044B06)),
              onPressed: () {},
              child: const Text(
                'Send Patient for tests',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0xFF03FF0C)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrescribeMedicinesToPatient(
                              patient_name: patient_name,
                            )));
              },
              child: const Text(
                'Prescribe Medicines',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Tests_List extends StatefulWidget {
  final String patient_name;
  final String test_name;
  const Tests_List({
    super.key,
    required this.patient_name,
    required this.test_name,
  });

  @override
  State<Tests_List> createState() => _Tests_ListState();
}

class _Tests_ListState extends State<Tests_List> {
  bool isCheck = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Color(0xFFFFF389),
          border: Border.all(
            width: 1,
            color: Colors.blue,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Checkbox(
            value: isCheck,
            onChanged: (value) {
              setState(() {
                isCheck = !isCheck;
              });
            },
          ),
          TextButton(
            onPressed: () {
              ///Open information about test
            },
            child: Text(
              widget.test_name,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}
