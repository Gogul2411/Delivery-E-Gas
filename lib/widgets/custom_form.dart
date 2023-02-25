import 'package:egas_delivery/common/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomForm extends StatelessWidget {
  CustomForm({
    Key? key,
    required this.keyboardType,
    required this.myFocusNode,
    this.hintTxt,
    this.labelTxt,
    this.icon,
    this.formEnabled,
    this.iconData,
    this.maxlines,
    this.onChanged,
    this.initial,
    this.controller,
    required this.checkValidator,
    required this.obscureTxt,
  }) : super(key: key);

  final FocusNode myFocusNode;
  final TextInputType keyboardType;
  final bool obscureTxt;
  bool? formEnabled;
  Icon? iconData;
  String? labelTxt;
  String? hintTxt;
  String? initial;
  String? Function(String?)? checkValidator;
  Widget? icon;
  int? maxlines;
  TextEditingController? controller;
  void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxlines,
      enabled: formEnabled,
      focusNode: myFocusNode,
      cursorColor: Colors.black,
      obscureText: obscureTxt,
      controller: controller,
      initialValue: initial,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintTxt,
        hintStyle: const TextStyle(color: kPrimaryLightColor),
        labelText: labelTxt,
        labelStyle: TextStyle(
            color: myFocusNode.hasFocus ? Colors.black : kPrimaryLightColor),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: kPrimaryLightColor,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: kPrimaryLightColor,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        fillColor: kBackground,
        suffixIcon: icon,
      ),
      validator: checkValidator,
    );
  }
}
