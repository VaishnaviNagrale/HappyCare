// // ignore_for_file: avoid_web_libraries_in_flutter

// import 'dart:convert';
// import 'dart:io';
// import 'dart:js';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:happycare/screens/staff/patient.dart';
// import 'package:web3dart/web3dart.dart';
// import 'package:http/http.dart' as http;
// import 'package:web3dart/web3dart.dart' as prefix;
// import 'package:web_socket_channel/io.dart';

// class PatientService extends ChangeNotifier {
//   List<Patient> patients = [];
//   final String _rpcUrl =
//       Platform.isAndroid ? 'http://10.0.2.2:7545' : 'http://127.0.0.1:7545';
//   final String _wsUrl =
//       Platform.isAndroid ? 'http://10.0.2.2:7545' : 'ws://127.0.0.1:7545';
//   bool isLoading = true;

//   final String _privatekey =
//       '0xa871b40e47be05c8906afaa848b237a169aa64cb0ee6196b7be7fdcd38132415';
//   late Web3Client _web3cient;

//   PatientService() {
//     init();
//   }
//   Future<void> init() async {
//     _web3cient = Web3Client(
//       _rpcUrl,
//       http.Client(),
//       socketConnector: () {
//         return IOWebSocketChannel.connect(_wsUrl).cast<String>();
//       },
//     );
//     await getABI();
//     await getCredentials();
//     await getDeployedContract();
//   }

//   late ContractAbi _abiCode;
//   late EthereumAddress _contractAddress;
//   late prefix.EthPrivateKey _creds;

//   Future<void> getABI() async {
//     String abiFile =
//         await rootBundle.loadString('build/contracts/NotesContract.json');
//     var jsonABI = jsonDecode(abiFile);
//     _abiCode =
//         ContractAbi.fromJson(jsonEncode(jsonABI['abi']), 'NotesContract');
//     _contractAddress =
//         EthereumAddress.fromHex(jsonABI["networks"]["5777"]["address"]);
//   }

//   Future<void> getCredentials() async {
//     _creds = prefix.EthPrivateKey.fromHex(_privatekey);
//   }

//   late prefix.DeployedContract _deployedContract;
//   late prefix.ContractFunction _createPatient;
//   late prefix.ContractFunction _deletePatient;
//   late prefix.ContractFunction _patients;
//   late prefix.ContractFunction _patientCount;

//   Future<void> getDeployedContract() async {
//     _deployedContract = prefix.DeployedContract(_abiCode, _contractAddress);
//     _createPatient = _deployedContract.function('registerPatientDapp');
//     _deletePatient = _deployedContract.function('deletePatientDapp');
//     _patients = _deployedContract.function('patients');
//     _patientCount = _deployedContract.function('patientCount');
//     await fetchPatients();
//   }

//    Future<void> fetchPatients() async {
//     List totalTaskList = await _web3cient.call(
//       contract: _deployedContract,
//       function: _patientCount,
//       params: [],
//     );

//     int totalTaskLen = totalTaskList[0].toInt();
//     patients.clear();
//     for (var i = 0; i < totalTaskLen; i++) {
//       var temp = await _web3cient.call(
//           contract: _deployedContract,
//           function: _patients,
//           params: [BigInt.from(i)]);
//       if (temp[1] != "") {
//         patients.add(
//           Patient(
//             id: (temp[0] as BigInt).toInt(),
//             title: temp[1],
//             description: temp[2], name: '', mobileNo: '', adharNo: '', address: '', age: null, gender: null,
//           ),
//         );
//       }
//     }
//     isLoading = false;

//     notifyListeners();
//   }

//   Future<void> _addPatientToBlockchain() async {
//     try {
//       // Assuming you already have _web3client, _creds, _deployedContract available
//       if (_deployedContract == null) {
//         throw Exception("Contract not initialized");
//       }
//       final BigInt id =
//           BigInt.from(patients.length + 1); // Generate a unique ID
//       final String name = nameController.text;
//       final String mobileNo = mobileNoController.text;
//       final String adharNo = adharNoController.text;
//       final String address = addressController.text;
//       final int age = int.tryParse(ageController.text)!;
//       final bool gender = isMale ?? false;
//       final bool isPaidCheckupFees = isPaid ?? false;

//       final transactionHash = await _web3client.sendTransaction(
//         _creds,
//         prefix.Transaction.callContract(
//           contract: _deployedContract,
//           function: _createPatient,
//           parameters: [
//             id,
//             name,
//             mobileNo,
//             adharNo,
//             address,
//             age,
//             gender,
//             isPaidCheckupFees,
//           ],
//         ),
//       );

//       // Now the patient is added to the blockchain
//       final transactionReceipt =
//           await _web3client.getTransactionReceipt(transactionHash);

//       if (transactionReceipt!.status == null) {
//         // Transaction is pending
//         ScaffoldMessenger.of(context as BuildContext).showSnackBar(
//           const SnackBar(
//             backgroundColor: Colors.amber,
//             content: Text(
//               'Transaction is pending',
//               style: TextStyle(
//                 fontSize: 16.0,
//               ),
//             ),
//           ),
//         );
//       } else if (transactionReceipt.status == BigInt.zero) {
//         // Transaction failed
//         ScaffoldMessenger.of(context as BuildContext).showSnackBar(
//           const SnackBar(
//             backgroundColor: Colors.red,
//             content: Text(
//               'Transaction failed',
//               style: TextStyle(
//                 fontSize: 16.0,
//               ),
//             ),
//           ),
//         );
//       } else if (transactionReceipt.status == BigInt.one) {
//         // Transaction succeeded, data stored in the blockchain
//         ScaffoldMessenger.of(context as BuildContext).showSnackBar(
//           const SnackBar(
//             backgroundColor: Colors.green,
//             content: Text(
//               'Transaction succeeded, data stored in the blockchain',
//               style: TextStyle(
//                 fontSize: 16.0,
//               ),
//             ),
//           ),
//         );
//       } else {
//         // Unknown status, handle accordingly
//         ScaffoldMessenger.of(context as BuildContext).showSnackBar(
//           const SnackBar(
//             backgroundColor: Colors.grey,
//             content: Text(
//               'Unknown status, handle accordingly',
//               style: TextStyle(
//                 fontSize: 16.0,
//               ),
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       print('Error adding patient to blockchain: $e');
//       ScaffoldMessenger.of(context as BuildContext).showSnackBar(
//         SnackBar(
//           backgroundColor: Colors.grey,
//           content: Text(
//             'Error adding patient to blockchain: $e',
//             style: TextStyle(
//               fontSize: 16.0,
//             ),
//           ),
//         ),
//       );
//       // Handle the error accordingly
//       Navigator.pop(context as BuildContext);
//     }
//   }
// }
