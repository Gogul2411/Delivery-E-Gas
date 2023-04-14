import 'package:egas_delivery/common/colors.dart';
import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackground,
      child: Center(
        child: Image.asset(
          "assets/images/no_internet.gif",
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
