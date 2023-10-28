// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:happycare/dbHelper/mongodb.dart';
import 'package:happycare/screens/doctor/prescribe_medicines.dart';

class Test {
  final String name;

  Test({required this.name});
}

class PrescribeTestsToPatient extends StatefulWidget {
  final String patient_name;
  const PrescribeTestsToPatient({super.key, required this.patient_name});

  @override
  State<PrescribeTestsToPatient> createState() =>
      _PrescribeTestsToPatientState();
}

class _PrescribeTestsToPatientState extends State<PrescribeTestsToPatient> {
  final List<Test> prescribedTests = [];

  void _addTest(String name) {
    setState(() {
      prescribedTests.add(Test(name: name));
    });
    Navigator.pop(context);
  }

  void _addTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddTaskBottomSheet(
            addTest: _addTest,
            patient_name: widget.patient_name,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF9900),
        title: Text(
          'Medical tests that should be assigned to ${widget.patient_name}',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF28802B),
        onPressed: () {
          _addTask(context);
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: Image.asset('assets/images/medical_tests.jpg'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: prescribedTests.length,
              itemBuilder: (context, index) {
                final medicine = prescribedTests[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                    tileColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    title: Row(
                      children: [
                        const Text(
                          'Test : ',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          medicine.name,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        // Add logic to delete the medicine here
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          //     onPressed: () {},
          //     child: const Text(
          //       'Send Patient for test',
          //       style: TextStyle(
          //         fontSize: 15,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrescribeMedicinesToPatient(
                              patient_name: widget.patient_name,
                            )));
              },
              child: const Text(
                'Prescribe Medicines',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddTaskBottomSheet extends StatefulWidget {
  final Function(String name) addTest;
  final String patient_name;

  const AddTaskBottomSheet({
    Key? key,
    required this.addTest,
    required this.patient_name,
  }) : super(key: key);

  @override
  _AddTaskBottomSheetState createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void TestsPrescribedByDoctor(String patientName) async {
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
            await db.collection('TestPrescribedByDoctor').insertOne({
          'patient name': patientName,
          'test name': nameController.text,
          'date-time': DateTime.now(),
        });

        if (mongoResult == null) {
          // Handle MongoDB insertion error
          print('Error: MongoDB data insertion failed');
          return;
        }
        // Add user data to Firestore
        await firestore.collection('TestPrescribedByDoctor').add(
          {
            'patient name': patientName,
            'test name': nameController.text,
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

    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Add Tests',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Color(0xFF083745),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: TextField(
                autofocus: true,
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Test Name',
                  hintText: 'Blood Test',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Color(0xFF0B406B)),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B3E68),
                  ),
                  onPressed: () {
                    final name = nameController.text;
                    if (name.isNotEmpty) {
                      widget.addTest(name);
                      TestsPrescribedByDoctor(widget.patient_name);
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// class TestListScreen extends StatelessWidget {
//   final String patient_name;
//   const TestListScreen({super.key, required this.patient_name});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFFFF9900),
//         title: Text(
//           'Medical tests that should be assigned to $patient_name',
//           maxLines: 3,
//           overflow: TextOverflow.ellipsis,
//         ),
//         centerTitle: true,
//       ),
//       body: ListView(
//         children: [
//           Tests_List(patient_name: patient_name, test_name: 'Blood Test'),
//           Tests_List(patient_name: patient_name, test_name: 'Suger Test'),
//           Tests_List(
//               patient_name: patient_name, test_name: 'Blood Pressure Test'),
//           Tests_List(patient_name: patient_name, test_name: 'X-ray'),
//           Tests_List(patient_name: patient_name, test_name: 'ECG Test'),
//           Tests_List(patient_name: patient_name, test_name: 'MRI Scan'),
//           Tests_List(patient_name: patient_name, test_name: 'Blood Test'),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
//             child: ElevatedButton(
//               style:
//                   ElevatedButton.styleFrom(backgroundColor: Color(0xFF044B06)),
//               onPressed: () {},
//               child: const Text(
//                 'Send Patient for tests',
//                 style: TextStyle(
//                   fontSize: 20,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
//             child: ElevatedButton(
//               style:
//                   ElevatedButton.styleFrom(backgroundColor: Color(0xFF03FF0C)),
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => PrescribeMedicinesToPatient(
//                               patient_name: patient_name,
//                             )));
//               },
//               child: const Text(
//                 'Prescribe Medicines',
//                 style: TextStyle(
//                   fontSize: 20,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Tests_List extends StatefulWidget {
//   final String patient_name;
//   final String test_name;
//   const Tests_List({
//     super.key,
//     required this.patient_name,
//     required this.test_name,
//   });

//   @override
//   State<Tests_List> createState() => _Tests_ListState();
// }

// class _Tests_ListState extends State<Tests_List> {
//   bool isCheck = false;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(10.0),
//       decoration: BoxDecoration(
//           color: Color(0xFFFFF389),
//           border: Border.all(
//             width: 1,
//             color: Colors.blue,
//           )),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Checkbox(
//             value: isCheck,
//             onChanged: (value) {
//               setState(() {
//                 isCheck = !isCheck;
//               });
//             },
//           ),
//           TextButton(
//             onPressed: () {
//               ///Open information about test
//             },
//             child: Text(
//               widget.test_name,
//               style: const TextStyle(
//                   fontSize: 18,
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//           const SizedBox(
//             width: 5,
//           ),
//         ],
//       ),
//     );
//   }
// }
