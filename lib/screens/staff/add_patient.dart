// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';
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
  String _name = '';
  String _mobileNo = '';
  String _adharNo = '';
  String _address = '';
  int? _age;
  bool? _isMale;
  bool? _isPaid;

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
    String rpcUrl = 'http://127.0.0.1:7545';
    String wsUrl = 'ws://127.0.0.1:7545';
    _web3client = prefix.Web3Client(rpcUrl, http.Client(), socketConnector: () {
      return IOWebSocketChannel.connect(wsUrl).cast<String>();
    });
    await getABI();
    getCredentials();
    getDeployedContract();
  }

  final String _privatekey = PRIVATE_KEY;

  late prefix.ContractAbi _abiCode;
  late prefix.EthereumAddress _contractAddress;

  Future<void> getABI() async {
    //String abiFile = await rootBundle.loadString('assets/PatientContract.json');
    String abiFile = await rootBundle.loadString('assets/PatientContract.json');
    print(abiFile);
    var jsonABI = jsonDecode(abiFile);
    _abiCode = prefix.ContractAbi.fromJson(
        jsonEncode(jsonABI['abi']), 'PatientContract');
    print('ABI Code: $_abiCode'); // Add this line to print ABI code
    //   _abiCode = " [
    //   {
    //     "anonymous": false,
    //     "inputs": [
    //       {
    //         "indexed": false,
    //         "internalType": "uint256",
    //         "name": "id",
    //         "type": "uint256"
    //       }
    //     ],
    //     "name": "DeletePatientToDapp",
    //     "type": "event"
    //   },
    //   {
    //     "anonymous": false,
    //     "inputs": [
    //       {
    //         "indexed": false,
    //         "internalType": "uint256",
    //         "name": "id",
    //         "type": "uint256"
    //       },
    //       {
    //         "indexed": false,
    //         "internalType": "string",
    //         "name": "p_name",
    //         "type": "string"
    //       },
    //       {
    //         "indexed": false,
    //         "internalType": "string",
    //         "name": "p_mobileNo",
    //         "type": "string"
    //       },
    //       {
    //         "indexed": false,
    //         "internalType": "string",
    //         "name": "p_adharNo",
    //         "type": "string"
    //       },
    //       {
    //         "indexed": false,
    //         "internalType": "string",
    //         "name": "p_address",
    //         "type": "string"
    //       },
    //       {
    //         "indexed": false,
    //         "internalType": "string",
    //         "name": "p_age",
    //         "type": "string"
    //       },
    //       {
    //         "indexed": false,
    //         "internalType": "string",
    //         "name": "p_gender",
    //         "type": "string"
    //       },
    //       {
    //         "indexed": false,
    //         "internalType": "string",
    //         "name": "p_datetime",
    //         "type": "string"
    //       }
    //     ],
    //     "name": "RegisterPatientToDapp",
    //     "type": "event"
    //   },
    //   {
    //     "constant": true,
    //     "inputs": [],
    //     "name": "patientCount",
    //     "outputs": [
    //       {
    //         "internalType": "uint256",
    //         "name": "",
    //         "type": "uint256"
    //       }
    //     ],
    //     "payable": false,
    //     "stateMutability": "view",
    //     "type": "function"
    //   },
    //   {
    //     "constant": true,
    //     "inputs": [
    //       {
    //         "internalType": "uint256",
    //         "name": "",
    //         "type": "uint256"
    //       }
    //     ],
    //     "name": "patients",
    //     "outputs": [
    //       {
    //         "internalType": "uint256",
    //         "name": "id",
    //         "type": "uint256"
    //       },
    //       {
    //         "internalType": "string",
    //         "name": "p_name",
    //         "type": "string"
    //       },
    //       {
    //         "internalType": "string",
    //         "name": "p_mobileNo",
    //         "type": "string"
    //       },
    //       {
    //         "internalType": "string",
    //         "name": "p_adharNo",
    //         "type": "string"
    //       },
    //       {
    //         "internalType": "string",
    //         "name": "p_address",
    //         "type": "string"
    //       },
    //       {
    //         "internalType": "string",
    //         "name": "p_age",
    //         "type": "string"
    //       },
    //       {
    //         "internalType": "string",
    //         "name": "p_gender",
    //         "type": "string"
    //       },
    //       {
    //         "internalType": "string",
    //         "name": "p_datetime",
    //         "type": "string"
    //       }
    //     ],
    //     "payable": false,
    //     "stateMutability": "view",
    //     "type": "function"
    //   },
    //   {
    //     "constant": false,
    //     "inputs": [
    //       {
    //         "internalType": "string",
    //         "name": "_name",
    //         "type": "string"
    //       },
    //       {
    //         "internalType": "string",
    //         "name": "_mobileNo",
    //         "type": "string"
    //       },
    //       {
    //         "internalType": "string",
    //         "name": "_adharNo",
    //         "type": "string"
    //       },
    //       {
    //         "internalType": "string",
    //         "name": "_address",
    //         "type": "string"
    //       },
    //       {
    //         "internalType": "string",
    //         "name": "_age",
    //         "type": "string"
    //       },
    //       {
    //         "internalType": "string",
    //         "name": "_gender",
    //         "type": "string"
    //       },
    //       {
    //         "internalType": "string",
    //         "name": "_datetime",
    //         "type": "string"
    //       }
    //     ],
    //     "name": "registerPatientDapp",
    //     "outputs": [],
    //     "payable": false,
    //     "stateMutability": "nonpayable",
    //     "type": "function"
    //   },
    //   {
    //     "constant": false,
    //     "inputs": [
    //       {
    //         "internalType": "uint256",
    //         "name": "_id",
    //         "type": "uint256"
    //       }
    //     ],
    //     "name": "deletePatientDapp",
    //     "outputs": [],
    //     "payable": false,
    //     "stateMutability": "nonpayable",
    //     "type": "function"
    //   }
    // ]";
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

  Future<bool> _addPatientToBlockchain() async {
    try {
      // Assuming you already have _web3client, _creds, _deployedContract available
      // BigInt id = BigInt.from(patients.length + 1); // Generate a unique ID
      String name = nameController.text;
      String mobileNo = mobileNoController.text;
      String adharNo = adharNoController.text;
      String address = addressController.text;
      // DateTime dateTime = DateTime(2023, 03, 02, 12, 30, 0);
      // int unixTimestamp = dateTime.millisecondsSinceEpoch ~/ 1000;
      int age = int.tryParse(ageController.text)!;
      bool gender = _isMale ?? false;
      bool isPaidCheckupFees = _isPaid ?? false;
      // print("seploy contract $_deployedContract");

      // Add debugging to check the values of parameters
      print('Adding patient to blockchain with the following parameters:');
      // print('id: $id');
      print('name: $name');
      print('mobileNo: $mobileNo');
      print('adharNo: $adharNo');
      print('address: $address');
      //print('date_time: $unixTimestamp');
      print('age: $age');
      print('gender: $gender');
      print('isPaidCheckupFees: $isPaidCheckupFees');

      print(_abiCode);
      print(_contractAddress);
      final transactionHash = await _web3client.sendTransaction(
        _creds,
        prefix.Transaction.callContract(
          contract: _deployedContract,
          function: _createPatient,
          parameters: [
            // BigInt.from(1), // uint256
            _name.toString(), // string
            _mobileNo.toString(), // string
            _adharNo.toString(), // string
            _address.toString(), // string
            // unixTimestamp, // uint256 (make sure it's correctly formatted)
            _age.toString(), // uint256
            gender.toString(), // bool
            isPaidCheckupFees.toString(), // bool
          ],
        ),
      );

      // Now the patient is added to the blockchain
      final transactionReceipt =
          await _web3client.getTransactionReceipt(transactionHash);

      // if (transactionReceipt!.status != null) {
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => DisaesesListScreen(
      //           staff_name: widget.staffName,
      //           patient_name: _name,
      //         ),
      //       ),
      //     );
      // }
      if (transactionReceipt!.status == null) {
        // Transaction is pending
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.amber,
            content: Text(
              'Transaction is pending',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
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
                color: Colors.white,
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
                color: Colors.white,
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
                color: Colors.white,
              ),
            ),
          ),
        );
      }
      return true;
    } catch (e) {
      print('Error adding patient to blockchain: $e');
      return false;
      // Handle the error accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    void Registration() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        try {
          final db = MongoDatabase.getDatabase();
          final firestore = FirebaseFirestore.instance;

          if (db == null) {
            // Handle MongoDB connection error
            print('Error: MongoDB connection failed');
            return;
          }
          final patientData = {
            'name': _name,
            'mobileNo': _mobileNo,
            'adharNo': _adharNo,
            'address': _address,
            'age': _age,
            'gender': _isMale,
            'date-time': DateTime.now(),
          };

          print('Patient data: $patientData');
          final mongoResult =
              await db.collection('patients').insertOne(patientData);
          print('MongoDB insertion result: $mongoResult');

          if (mongoResult == null) {
            print('Error: MongoDB insertion failed');
            return;
          }

          if (mongoResult.writeConcernError == null) {
            print('Data inserted successfully into MongoDB');

            // Wait for a moment before searching to ensure data is available
            await Future.delayed(const Duration(seconds: 1));

            final insertedData = await db
                .collection('patients')
                .findOne({'_id': mongoResult.id}); // Search by inserted ID

            if (insertedData != null) {
              print('Data found in MongoDB collection');
              // Print the found data
              print('Inserted Data: $insertedData');
            } else {
              print('Data not found in MongoDB collection');
            }
          }

          final firestoreResult = await firestore.collection('patients').add({
            'name': _name,
            'mobileNo': _mobileNo,
            'adharNo': _adharNo,
            'address': _address,
            'age': _age,
            'gender': _isMale,
            'date-time': DateTime.now(),
          });
          print('Firestore insertion result: $firestoreResult');
          if (firestoreResult == null) {
            print('Error: Firestore insertion failed');
            return;
          }
          bool blockchainSuccess = await _addPatientToBlockchain();
          if (blockchainSuccess == false) {
            print('Error: Blockchain operation failed');
            setState(() {
              patients.add(Patient(
                name: _name,
                mobileNo: _mobileNo,
                adharNo: _adharNo,
                address: _address,
                age: _age!,
                gender: _isMale,
                isPaidCheckupFees: _isPaid,
              ));
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  'Registration Successful',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DisaesesListScreen(
                  staff_name: widget.staffName,
                  patient_name: _name,
                ),
              ),
            );
            // return;
          }
        } catch (e) {
          print('Exception caught: $e');
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
            // fontWeight: FontWeight.bold,
            fontSize: 18,
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
                      return 'please enter patients full name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
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
                      return 'Please enter patients mobile number';
                    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return 'Please enter a valid mobile number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _mobileNo = value!;
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
                      return 'Please enter patients Aadhar number';
                    } else if (!RegExp(r'^[0-9]{12}$').hasMatch(value)) {
                      return 'Please enter a valid 12-digit Aadhar number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _adharNo = value!;
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
                    _address = value!;
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
                      return 'Please enter your age';
                    } else if (int.tryParse(value) == null ||
                        int.parse(value) <= 0) {
                      return 'Please enter a valid age';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _age = int.tryParse(value!);
                  },
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isMale ?? false,
                    onChanged: (value) {
                      setState(() {
                        _isMale = value;
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
                    value: !(_isMale ?? false),
                    onChanged: (value) {
                      setState(() {
                        _isMale = !value!;
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
                    value: _isPaid ?? false,
                    onChanged: (value) {
                      setState(() {
                        _isPaid = value;
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
                    value: !(_isPaid ?? false),
                    onChanged: (value) {
                      setState(() {
                        _isPaid = !value!;
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
