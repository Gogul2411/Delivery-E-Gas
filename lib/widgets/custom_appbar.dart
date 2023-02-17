import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  CustomAppBar({
    this.onPressed,
    this.leading,
    this.automaticallyImply,
    this.action,
    required this.appbarText,
    Key? key,
  }) : super(key: key);

  VoidCallback? onPressed;
  String appbarText;
  bool? automaticallyImply;
  Widget? leading;
  List<Widget>? action;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      centerTitle: true,
      elevation: 0.3,
      leading: leading,
      actions: action,
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
