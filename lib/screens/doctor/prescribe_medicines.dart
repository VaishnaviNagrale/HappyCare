// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names, unnecessary_null_comparison, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happycare/dbHelper/mongodb.dart';

class Medicine {
  final String name;
  final String quantity;
  final String noDays;

  Medicine({required this.name, required this.quantity, required this.noDays});
}

class PrescribeMedicinesToPatient extends StatefulWidget {
  final String patient_name;
  const PrescribeMedicinesToPatient({super.key, required this.patient_name});

  @override
  State<PrescribeMedicinesToPatient> createState() =>
      _PrescribeMedicinesToPatientState();
}

class _PrescribeMedicinesToPatientState
    extends State<PrescribeMedicinesToPatient> {
  final List<Medicine> prescribedMedicines = [];

  void _addMedicine(String name, String quantity, String noDays) {
    setState(() {
      prescribedMedicines
          .add(Medicine(name: name, quantity: quantity, noDays: noDays));
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
            addMedicine: _addMedicine, patient_name: widget.patient_name,
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
          'Prescribe medicines to ${widget.patient_name}',
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
            child: Image.asset('assets/images/medicines.png'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: prescribedMedicines.length,
              itemBuilder: (context, index) {
                final medicine = prescribedMedicines[index];
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
                    title: Text(
                      'Medicine : ${medicine.name}',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quantity : ${medicine.quantity}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Days to take : ${medicine.noDays}',
                          style: const TextStyle(
                            fontSize: 15,
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
        ],
      ),
    );
  }
}

class AddTaskBottomSheet extends StatefulWidget {
  final Function(String name, String quantity, String noDays) addMedicine;
  final String patient_name;

  const AddTaskBottomSheet({Key? key, required this.addMedicine, required this.patient_name}) : super(key: key);

  @override
  _AddTaskBottomSheetState createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController noDaysController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void MedicinePrescribedByDoctor(String patientName) async {
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
            await db.collection('MedicinePrescribedByDoctor').insertOne({
          'patient name': patientName,
          'medicine name': nameController.text,
          'quantitiy': quantityController.text,
          'no days': noDaysController.text,
          'date-time': DateTime.now(),
        });

        if (mongoResult == null) {
          // Handle MongoDB insertion error
          print('Error: MongoDB data insertion failed');
          return;
        }
        // Add user data to Firestore
        await firestore.collection('MedicinePrescribedByDoctor').add(
          {
            'patient name': patientName,
            'medicine name': nameController.text,
            'quantitiy': quantityController.text,
            'no days': noDaysController.text,
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
              'Add Medicine',
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
                  labelText: 'Medicine Name',
                  hintText: 'Paracetmol',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: TextField(
                autofocus: true,
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  hintText: '6',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            TextField(
              autofocus: true,
              controller: noDaysController,
              decoration: const InputDecoration(
                labelText: 'Number of Days',
                hintText: '3 days',
                border: OutlineInputBorder(),
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
                    final quantity = quantityController.text;
                    final noDays = noDaysController.text;
                    if (name.isNotEmpty &&
                        quantity.isNotEmpty &&
                        noDays.isNotEmpty) {
                      widget.addMedicine(name, quantity, noDays);
                      MedicinePrescribedByDoctor(widget.patient_name);
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
