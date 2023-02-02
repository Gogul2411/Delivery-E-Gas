import 'dart:collection';
import 'package:egas_delivery/common/colors.dart';
import 'package:egas_delivery/screens/dashboard.dart';
import 'package:egas_delivery/screens/orders.dart';
import 'package:egas_delivery/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ListQueue<int> _navigationQueue = ListQueue();
  int _index = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    Orders(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (_navigationQueue.isEmpty) return true;
        setState(() {
          _navigationQueue.removeLast();
          int position = _navigationQueue.isEmpty ? 0 : _navigationQueue.last;
          _index = position;
        });
        return false;
      },
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_index),
        ),
        bottomNavigationBar: SizedBox(
          height: 80,
          width: double.infinity,
          child: StylishBottomBar(
            items: [
              BubbleBarItem(
                  icon: const Icon(Icons.home_outlined, size: 30),
                  title: const Text('Home'),
                  backgroundColor: kPrimaryColor),
              BubbleBarItem(
                  icon: const Icon(Icons.bar_chart_sharp, size: 30),
                  title: const Text('Orders'),
                  backgroundColor: kPrimaryColor),
              BubbleBarItem(
                  icon: const Icon(Icons.account_circle_outlined, size: 30),
                  title: const Text('Profile'),
                  backgroundColor: kPrimaryColor),
            ],
            unselectedIconColor: Colors.black45,
            barStyle: BubbleBarStyle.horizotnal,
            bubbleFillStyle: BubbleFillStyle.fill,
            elevation: 0.0,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
            opacity: 0.3,
            backgroundColor: Colors.white,
            currentIndex: _index,
            onTap: (index) {
              if (index != _index) {
                _navigationQueue.removeWhere((element) => element == index);
                _navigationQueue.addLast(index!);
                setState(
                  () {
                    _index = index;
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
