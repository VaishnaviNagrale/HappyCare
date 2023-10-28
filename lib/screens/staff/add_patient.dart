// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:happycare/dbHelper/constants.dart';
import 'package:happycare/dbHelper/mongodb.dart';
import 'package:happycare/screens/staff/assign_doctor/diseases_list_screen.dart';
import 'package:happycare/screens/payments/payment_home_screen.dart';
import 'package:happycare/screens/staff/patient.dart';
import 'package:web3dart/web3dart.dart' as prefix;
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class AddPatientScreen extends StatefulWidget {
  final String staffName;

  const AddPatientScreen({Key? key, required this.staffName}) : super(key: key);

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Patient> patients = [];
  String name = '';
  String mobileNo = '';
  String adharNo = '';
  String address = '';
  int? age;
  bool? isMale;
  bool? isPaid;
  late prefix.Web3Client _web3client;

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController adharNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeWeb3Client();
  }

  Future<void> _initializeWeb3Client() async {
    final String rpcUrl =
        Platform.isAndroid ? 'http://10.0.2.2:7545' : 'http://127.0.0.1:7545';
    final String wsUrl =
        Platform.isAndroid ? 'http://10.0.2.2:7545' : 'ws://127.0.0.1:7545';
    _web3client = prefix.Web3Client(rpcUrl, http.Client(), socketConnector: () {
      return IOWebSocketChannel.connect(wsUrl).cast<String>();
    });
    getABI();
    getCredentials();
    getDeployedContract();
  }

  final String _privatekey =
      PRIVATE_KEY;

  late prefix.ContractAbi _abiCode;
  late prefix.EthereumAddress _contractAddress;
  Future<void> getABI() async {
    String abiFile =
        await rootBundle.loadString('build/contracts/NotesContract.json');
    var jsonABI = jsonDecode(abiFile);
    _abiCode = prefix.ContractAbi.fromJson(
        jsonEncode(jsonABI['abi']), 'PatientContract');
    _contractAddress =
        prefix.EthereumAddress.fromHex(jsonABI["networks"]["5777"]["address"]);
  }

  late prefix.EthPrivateKey _creds;
  Future<void> getCredentials() async {
    _creds = prefix.EthPrivateKey.fromHex(_privatekey);
  }

  late prefix.DeployedContract _deployedContract;
  late prefix.ContractFunction _createPatient;
  late prefix.ContractFunction _deletePatient;
  late prefix.ContractFunction _patients;
  late prefix.ContractFunction _patientCount;

  Future<void> getDeployedContract() async {
    _deployedContract = prefix.DeployedContract(_abiCode, _contractAddress);
    _createPatient = _deployedContract.function('registerPatientDapp');
    _deletePatient = _deployedContract.function('deletePatientDapp');
    _patients = _deployedContract.function('patients');
    _patientCount = _deployedContract.function('patientCount');
  }

  Future<void> _addPatientToBlockchain() async {
    try {
      // Assuming you already have _web3client, _creds, _deployedContract available
      final BigInt id =
          BigInt.from(patients.length + 1); // Generate a unique ID
      final String name = nameController.text;
      final String mobileNo = mobileNoController.text;
      final String adharNo = adharNoController.text;
      final String address = addressController.text;
      final int age = int.tryParse(ageController.text)!;
      final bool gender = isMale ?? false;
      final bool isPaidCheckupFees = isPaid ?? false;

      final transactionHash = await _web3client.sendTransaction(
        _creds,
        prefix.Transaction.callContract(
          contract: _deployedContract,
          function: _createPatient,
          parameters: [
            id,
            name,
            mobileNo,
            adharNo,
            address,
            age,
            gender,
            isPaidCheckupFees,
          ],
        ),
      );

      // Now the patient is added to the blockchain
      final transactionReceipt =
          await _web3client.getTransactionReceipt(transactionHash);

      if (transactionReceipt!.status == null) {
        // Transaction is pending
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.amber,
            content: Text(
              'Transaction is pending',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        );
      } else if (transactionReceipt.status == BigInt.zero) {
        // Transaction failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Transaction failed',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        );
      } else if (transactionReceipt.status == BigInt.one) {
        // Transaction succeeded, data stored in the blockchain
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Transaction succeeded, data stored in the blockchain',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        );
      } else {
        // Unknown status, handle accordingly
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.grey,
            content: Text(
              'Unknown status, handle accordingly',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      print('Error adding patient to blockchain: $e');
      // Handle the error accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    void Registration() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        try {
          final firestore = FirebaseFirestore.instance;
          final db = MongoDatabase.getDatabase();

          if (db == null) {
            // Handle MongoDB connection error
            print('Error: MongoDB connection failed');
            return;
          }

          // Insert data into MongoDB
          final mongoResult = await db.collection('patients').insertOne({
            'name': name,
            'mobileNo': mobileNo,
            'adharNo': adharNo,
            'address': address,
            'age': age,
            'gender': isMale,
            'date-time': DateTime.now(),
          });

          if (mongoResult == null) {
            // Handle MongoDB insertion error
            print('Error: MongoDB data insertion failed');
            return;
          }
          // Add user data to Firestore
          await firestore.collection('patients').add(
            {
              'name': name,
              'mobileNo': mobileNo,
              'adharNo': adharNo,
              'address': address,
              'age': age,
              'gender': isMale,
              'date-time': DateTime.now(),
            },
          );
          await _addPatientToBlockchain();
          setState(() {
            patients.add(Patient(
              name: name,
              mobileNo: mobileNo,
              adharNo: adharNo,
              address: address,
              age: age!,
              gender: isMale,
            ));
          });
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
                staff_name: widget.staffName,
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
        backgroundColor: const Color(0xFFFF9900),
        title: const Text(
          'Add New Patient Form',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
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
                  keyboardType: TextInputType.name,
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
                  controller: mobileNoController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter mobile number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    mobileNo = value!;
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
                  controller: adharNoController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter adhar no';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    adharNo = value!;
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
              Row(
                children: [
                  Checkbox(
                    value: isPaid ?? false,
                    onChanged: (value) {
                      setState(() {
                        isPaid = value;
                      });
                    },
                  ),
                  const Text(
                    'Cash',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: !(isPaid ?? false),
                    onChanged: (value) {
                      setState(() {
                        isPaid = !value!;
                      });
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PaymentScreen()));
                    },
                    child: const Text(
                      'Online Payment',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15.0,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF03FF0C)),
                  onPressed: () {
                    Registration();
                  },
                  child: const Text(
                    'Assign Doctor',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
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
