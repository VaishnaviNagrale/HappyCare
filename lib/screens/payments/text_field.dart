import 'package:flutter/material.dart';

Widget textField(Size size, String text, bool isNumerical,
    TextEditingController controller) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: size.height / 50),
    child: SizedBox(
      height: size.height / 15,
      width: size.width / 1.1,
      child: TextField(
        controller: controller,
        keyboardType: isNumerical ? TextInputType.number : null,
        decoration: InputDecoration(
          hintText: text,
          border:const OutlineInputBorder(),
        ),
      ),
    ),
  );
}