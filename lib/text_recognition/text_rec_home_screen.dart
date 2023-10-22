import 'package:flutter/material.dart';
import 'package:happycare/text_recognition/widgets/text_recognition_widget.dart';

class TextRecognitionHomeScreen extends StatelessWidget {
  const TextRecognitionHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9900),
        title: const Text(
          'Text Recognition',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(height: 25),
            TextRecognitionWidget(),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
