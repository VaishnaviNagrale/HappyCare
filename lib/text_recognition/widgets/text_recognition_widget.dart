// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:happycare/text_recognition/api/google_ml_api.dart';
import 'package:happycare/text_recognition/widgets/text_area_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'controls_widget.dart';

class TextRecognitionWidget extends StatefulWidget {
  const TextRecognitionWidget({
    Key? key,
  });

  @override
  _TextRecognitionWidgetState createState() => _TextRecognitionWidgetState();
}

class _TextRecognitionWidgetState extends State<TextRecognitionWidget> {
  bool scanning = false;
  String text = '';
  File? image;
  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            Expanded(child: buildImage()),
            const SizedBox(height: 16),
            ControlsWidget(
              onClickedPickImage: pickImage,
              onClickedScanText: scanText,
              onClickedClear: clear,
            ),
            const SizedBox(height: 16),
            TextAreaWidget(
              text: text,
              onClickedCopy: copyToClipboard,
            ),
          ],
        ),
      );

  Widget buildImage() => Container(
        child: image != null
            ? Image.file(image!)
            : const Icon(Icons.photo, size: 80, color: Colors.black),
      );

  Future pickImage() async {
    final file = await showImagePicker(context);
    setImage(File(file!.path));
  }

  Future scanText() async {
    showDialog(
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
      context: context,
    );

    final text = await GoogleMLapi.recogniseText(image!);
    // final text = await FlutterTesseractOcr.extractText(image!.path, args: {
    //   "psm": "4",
    //   "preserve_interword_spaces": "1",
    // });
    // final textRecognizer = RecognizedText(script: TextRecognitionScript.latin);
    // final RecognizedText recognizedText = await textRecognizer.processImage(image);
// String text = recognizedText.text;
    setText(text);
    Navigator.of(context).pop();
  }

  void clear() {
    setImage(image!);
    setText('');
  }

  void copyToClipboard() {
    if (text.trim() != '') {
      FlutterClipboard.copy(text);
    }
  }

  void setImage(File newImage) {
    setState(() {
      image = newImage;
    });
  }

  void setText(String newText) {
    setState(() {
      text = newText;
    });
  }
}

Future<XFile?> showImagePicker(BuildContext context) async {
  final completer = Completer<
      XFile?>(); // Create a Completer to handle the asynchronous operation

  showModalBottomSheet(
    context: context,
    builder: (builder) {
      return Card(
        color: Colors.white70,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 9,
          margin: const EdgeInsets.only(top: 8.0),
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: InkWell(
                  child: const Column(
                    children: [
                      Icon(
                        Icons.image,
                        size: 40.0,
                        color: Colors.blue,
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        "Gallery",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      )
                    ],
                  ),
                  onTap: () async {
                    final file = await _imgFromGallery(); // Await the result
                    completer.complete(
                        file); // Complete the future with the selected file
                    Navigator.pop(context);
                  },
                ),
              ),
              Expanded(
                child: InkWell(
                  child: const SizedBox(
                    child: Column(
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: Colors.red,
                          size: 40.0,
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          "Camera",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        )
                      ],
                    ),
                  ),
                  onTap: () async {
                    final file = await _imgFromCamera(); // Await the result
                    completer.complete(
                        file); // Complete the future with the selected file
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  return completer.future; // Return the future from the Completer
}

Future<XFile?> _imgFromGallery() async {
  final file = await ImagePicker().pickImage(source: ImageSource.gallery);
  return file;
}

Future<XFile?> _imgFromCamera() async {
  final file = await ImagePicker().pickImage(
    source: ImageSource.camera,
    imageQuality: 50,
  );
  return file;
}
