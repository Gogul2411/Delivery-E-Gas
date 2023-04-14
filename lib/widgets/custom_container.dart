import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DashContainer extends StatelessWidget {
  DashContainer({
    required this.containerColor,
    required this.iconData,
    required this.statusText,
    required this.countText,
    Key? key,
  }) : super(key: key);
  Color containerColor;
  Icon iconData;
  String statusText;
  String countText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 187,
      width: 187,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: containerColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            iconData,
            Text(statusText,style: const TextStyle(fontSize: 16),),
            Text(
              countText,
              style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
