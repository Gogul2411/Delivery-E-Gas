// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:egas_delivery/screens/bottom_navigation.dart';
import 'package:egas_delivery/screens/login_screen.dart';
import 'package:egas_delivery/screens/no_internet.dart';
import 'package:egas_delivery/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State {
  Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;

  @override
  void initState() {
    super.initState();
    _connectivity.initialise();
    _connectivity.myStream.listen(
      (source) {
        setState(() => _source = source);
      },
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.mobile:
        print('Mobile: Online');
        break;
      case ConnectivityResult.wifi:
        print('WiFi: Online');
        break;
      case ConnectivityResult.none:
      default:
        return const NoInternet();
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'egas delivery',
      theme: ThemeData(
        fontFamily: "Roboto",
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
          ),
        ),
      ),
      home: const Splash(),
      routes: {
        '/signin': (BuildContext context) => const LoginScreen(),
        '/homePage': (BuildContext context) => const HomePage(),
      },
    );
  }

  @override
  void dispose() {
    _connectivity.disposeStream();
    super.dispose();
  }
}

class MyConnectivity {
  MyConnectivity._();

  static final _instance = MyConnectivity._();
  static MyConnectivity get instance => _instance;
  final _connectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;

  void initialise() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _checkStatus(result);
    _connectivity.onConnectivityChanged.listen(
      (result) {
        _checkStatus(result);
      },
    );
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({result: isOnline});
  }

  void disposeStream() => _controller.close();
}