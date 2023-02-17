import 'package:egas_delivery/common/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton({
    required this.buttonText,
    required this.onPressed,
    Key? key,
  }) : super(key: key);
  VoidCallback onPressed;
  String buttonText;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        shape: const StadiumBorder(),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(letterSpacing: 1),
      ),
    );
  }
}
