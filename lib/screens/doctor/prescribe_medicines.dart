import 'package:flutter/material.dart';

class Medicine {
  final String name;
  final String quantityAndDays;

  Medicine({required this.name, required this.quantityAndDays});
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
  final List<Medicine> prescribedMedicines =
      []; // List to store prescribed medicines

  // Function to add a medicine to the list
  void _addMedicine(String name, String quantityAndDays) {
    setState(() {
      prescribedMedicines
          .add(Medicine(name: name, quantityAndDays: quantityAndDays));
    });
    Navigator.pop(context); // Close the bottom sheet
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
            addMedicine: _addMedicine,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Prescribe medicines to ${widget.patient_name}',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
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
            child: Image.asset('assets/images/medicines.jpg'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: prescribedMedicines.length,
              itemBuilder: (context, index) {
                final medicine = prescribedMedicines[index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 1,
                        horizontal: 20), // Padding around the content
                    tileColor: Colors.grey[100], // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                      side: BorderSide(color: Colors.grey[300]!), // Border
                    ),
                    title: Text(
                      medicine.name,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      medicine.quantityAndDays,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
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
  final Function(String name, String quantityAndDays) addMedicine;

  AddTaskBottomSheet({Key? key, required this.addMedicine}) : super(key: key);

  @override
  _AddTaskBottomSheetState createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Add Medicine',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
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
            TextField(
              autofocus: true,
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity and Number of Days',
                hintText: '6 for 3 days',
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
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text;
                    final quantityAndDays = quantityController.text;
                    if (name.isNotEmpty && quantityAndDays.isNotEmpty) {
                      widget.addMedicine(name, quantityAndDays);
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
