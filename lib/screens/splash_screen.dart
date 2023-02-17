import 'package:egas_delivery/screens/bottom_navigation.dart';
import 'package:egas_delivery/common/colors.dart';
import 'package:egas_delivery/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
    getPref();
  }

  _navigatetohome() async {
    await Future.delayed(const Duration(milliseconds: 3000), () {});
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            (_loginStatus == null) ? const LoginScreen() : const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double height = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    double width = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.grey[200],
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: kPrimaryColor,
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(-56),
              child: Center(),
            ),
          ),
          body: Container(
            color: Colors.white,
            child: Center(
              // ignore: avoid_unnecessary_containers
              child: Image.asset(
                "assets/images/splash.png",
                height: 250,
                width: 250,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ignore: prefer_typing_uninitialized_variables
  var _loginStatus;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(
      () {
        _loginStatus = preferences.getString("mobileNumber");
      },
    );
  }
}
