// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:happycare/dbHelper/mongodb.dart';

class MedicineUpdateNurse extends StatefulWidget {
  final String medicine_name;
  final String quantity;
  final int noDays;

  const MedicineUpdateNurse({
    Key? key,
    required this.medicine_name,
    required this.quantity,
    required this.noDays,
  }) : super(key: key);

  @override
  _MedicineUpdateNurseState createState() => _MedicineUpdateNurseState();
}

class _MedicineUpdateNurseState extends State<MedicineUpdateNurse> {
  List<Map<String, bool>> checkBoxValues = [];

  @override
  void initState() {
    super.initState();
    // Initialize checkbox values based on the number of days
    for (var i = 0; i < widget.noDays; i++) {
      checkBoxValues.add({
        'morning': false,
        'afternoon': false,
        'evening': false,
      });
    }
  }

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
                )),
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
                      'Medicine Name :',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' ${widget.medicine_name}',
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
                          ' ${widget.quantity}',
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
                          ' ${widget.noDays}',
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
          ),
          Expanded(
            child: ListView.builder(
              itemCount: checkBoxValues.length,
              itemBuilder: (context, index) {
                final dayNumber =
                    index + 1; // Display day number starting from 1
                final checkBoxValue = checkBoxValues[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Day $dayNumber:',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      CheckboxListTile(
                        title: const Text('Morning'),
                        value: checkBoxValue['morning'] ?? false,
                        onChanged: (value) {
                          setState(() {
                            checkBoxValues[index]['morning'] = value ?? false;
                          });
                        },
                      ),

                      CheckboxListTile(
                        title: const Text('Afternoon'),
                        value: checkBoxValue['afternoon'] ?? false,
                        onChanged: (value) {
                          setState(() {
                            checkBoxValues[index]['afternoon'] = value ?? false;
                          });
                        },
                      ),

                      CheckboxListTile(
                        title: const Text('Evening'),
                        value: checkBoxValue['evening'] ?? false,
                        onChanged: (value) {
                          setState(() {
                            checkBoxValues[index]['evening'] = value ?? false;
                          });
                        },
                      ),

                      const Divider(
                        color: Colors.black,
                        thickness: 1.2,
                      ), // Divider for separation
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF044B06)),
            onPressed: () async {
              final db = MongoDatabase.getDatabase();
              if (db == null) {
                // Handle MongoDB connection error
                print('Error: MongoDB connection failed');
                return;
              }

              for (var i = 0; i < checkBoxValues.length; i++) {
                final dayUpdates = checkBoxValues[i];
                final morning = dayUpdates['morning'] ?? false;
                final afternoon = dayUpdates['afternoon'] ?? false;
                final evening = dayUpdates['evening'] ?? false;

                try {
                  // Insert data into MongoDB collection
                  await db
                      .collection('PatientMedicineReportUpdatesByNurse')
                      .insertOne({
                    'medicine_name': widget.medicine_name,
                    'day_number': i + 1,
                    'morning': morning,
                    'afternoon': afternoon,
                    'evening': evening,
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
              }
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
