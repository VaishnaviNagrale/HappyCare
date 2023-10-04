// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:happycare/screens/staff/assign_doctor/diseases_list_screen.dart';

class AddPatientScreen extends StatefulWidget {
  final String staff_name;
  const AddPatientScreen({Key? key, required this.staff_name})
      : super(key: key);

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String mobile_no = '';
  String adhar_no = '';
  String address = '';
  int? age;
  bool? isMale;

  TextEditingController nameController = TextEditingController();
  TextEditingController mobilenoController = TextEditingController();
  TextEditingController adharnoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void Registration() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        try {
          final firestore = FirebaseFirestore.instance;
          // Add user data to Firestore
          await firestore.collection('patients').add(
            {
              'name': name,
              'mobileNo': mobile_no,
              'adharNo': adhar_no,
              'address': address,
              'age': age,
              'gender': isMale,
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DisaesesListScreen(
                staff_name: widget.staff_name,
                patient_name: name,
              ),
            ),
          );
        } catch (e) {
          print(e);
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Add New Patient Form',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 20),
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage('assets/images/stethoscope.jpg'),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  autofocus: false,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter full name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    name = value!;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  autofocus: false,
                  decoration: const InputDecoration(
                    labelText: 'Mobile No',
                    labelStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  controller: mobilenoController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter mobile number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    mobile_no = value!;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  autofocus: false,
                  decoration: const InputDecoration(
                    labelText: 'Adhar No',
                    labelStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  controller: adharnoController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter adhar no';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    adhar_no = value!;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  autofocus: false,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    labelStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  controller: addressController,
                  keyboardType: TextInputType.streetAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    address = value!;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  autofocus: false,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    labelStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter age';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    age = int.tryParse(value!);
                  },
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: isMale ?? false,
                    onChanged: (value) {
                      setState(() {
                        isMale = value;
                      });
                    },
                  ),
                  const Text(
                    'Male',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              // Female Checkbox
              Row(
                children: [
                  Checkbox(
                    value: !(isMale ?? false),
                    onChanged: (value) {
                      setState(() {
                        isMale = !value!;
                      });
                    },
                  ),
                  const Text(
                    'Female',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Pay Checkup fees: ',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFECB3)),
                onPressed: () {},
                child: const Text(
                  'Cash',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Online Payment',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    Registration();
                  },
                  child: const Text(
                    'Assign Doctor',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
