// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:happycare/dbHelper/mongodb.dart';

class TestUpdateNurse extends StatefulWidget {
  final String test_name;

  const TestUpdateNurse({
    Key? key,
    required this.test_name,
  }) : super(key: key);

  @override
  _TestUpdateNurseState createState() => _TestUpdateNurseState();
}

class _TestUpdateNurseState extends State<TestUpdateNurse> {
  bool isTestDone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF9900),
        title: const Text(
          'Update Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF389),
              border: Border.all(
                width: 2,
                color: Colors.black,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
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
                      'Test Name :',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' ${widget.test_name}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          CheckboxListTile(
            title: const Text('Is Test Done?'),
            value: isTestDone,
            onChanged: (value) {
              setState(() {
                isTestDone = value ?? false;
              });
            },
          ),
          ElevatedButton(
            onPressed: () async {
              final db =
                  MongoDatabase.getDatabase(); // Get your MongoDB instance

              if (db == null) {
                // Handle MongoDB connection error
                print('Error: MongoDB connection failed');
                return;
              }

              try {
                // Insert data into MongoDB collection based on the checkbox value
                await db
                    .collection('PatientTestReportUpdatesByNurse')
                    .insertOne({
                  'test_name': widget.test_name,
                  'is_test_done': isTestDone,
                  'date-time': DateTime.now(),
                });
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                        'Data updated successfully!!',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                  Navigator.pop(context);
              } catch (e) {
                print('Error inserting data: $e');
                // Handle insertion error
              }
            },
            child: const Text('Save Test Status'),
          ),
        ],
      ),
    );
  }
}
