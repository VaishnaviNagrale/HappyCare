// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class DischargePatientScreen extends StatelessWidget {
  const DischargePatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFF82D7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF9900),
        title: const Text(
          'Discharge Patient',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(18.0),
              child: Image(
                image: AssetImage('assets/images/coming-soon.jpg'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // const Text(
            //   "coming soon.....",
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            // ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA18F58)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'back',
                style: TextStyle(
                    // color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
