import 'package:flutter/material.dart';
import 'package:happycare/screens/payments/text_field.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  late Razorpay _razorpay;

  void initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void lunchRazorpay() {
    int amountToPay = int.parse(amountController.text) * 100;
    var options = {
      'key': '',
      'amount': amountToPay,
      'name': nameController.text,
      'description': descriptionController.text,
      'prefill': {
        'contact': phoneNoController.text,
        'email': emailController.text
      },
    };
    try {
      _razorpay.open(options);
    } catch (error) {
      //print('Error: $error');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    //print('Payment Successful');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Payment Successful \n${response.orderId}\n${response.paymentId}\n${response.signature}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    //print('Payment Failed');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Payment Failed\n${response.code}\n${response.message}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    //print('Payment Failed');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Payment Failed',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void initState() {
    initializeRazorpay();
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9900),
        title: const Text(
          'Razorpay Payments',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              textField(size, "Name", false, nameController),
              textField(size, "Phone No.", true, phoneNoController),
              textField(size, "Email", false, emailController),
              textField(size, "Description", false, descriptionController),
              textField(size, "Amount", true, amountController),
              ElevatedButton(
                onPressed: lunchRazorpay,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Pay Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
