import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  CustomAppBar({
    this.onPressed,
    this.leading,
    this.automaticallyImply,
    required this.appbarText,
    Key? key,
  }) : super(key: key);

  VoidCallback? onPressed;
  String appbarText;
  bool? automaticallyImply;
  Widget? leading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0.1,
      centerTitle: true,
      leading: leading,
      title: Align(
        alignment: Alignment.topCenter,
        child: Text(
          appbarText,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(25.0),
        ),
      ),
    );
  }
}
