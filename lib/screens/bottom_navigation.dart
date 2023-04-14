import 'dart:collection';
import 'package:egas_delivery/common/colors.dart';
import 'package:egas_delivery/screens/orders.dart';
import 'package:egas_delivery/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import 'dashboard.dart';

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
          width: double.maxFinite,
          child: StylishBottomBar(
            option: BubbleBarOptions(
              padding: const EdgeInsets.all(10),
              unselectedIconColor: Colors.black45,
              barStyle: BubbleBarStyle.horizotnal,
              bubbleFillStyle: BubbleFillStyle.fill,
              borderRadius: const BorderRadius.all(
                Radius.circular(25),
              ),
              opacity: 0.3,
            ),
            items: [
              BottomBarItem(
                  icon: const Icon(Icons.home_outlined, size: 40),
                  title: const Text('Home',style: TextStyle(fontSize: 16),),
                  backgroundColor: kPrimaryColor),
              BottomBarItem(
                  icon: const Icon(Icons.bar_chart_sharp, size: 40),
                  title: const Text('Orders',style: TextStyle(fontSize: 16),),
                  backgroundColor: kPrimaryColor),
              BottomBarItem(
                  icon: const Icon(Icons.account_circle_outlined, size: 40),
                  title: const Text('Profile',style: TextStyle(fontSize: 16),),
                  backgroundColor: kPrimaryColor),
            ],
            //elevation: 0.5,
            hasNotch: true,
            backgroundColor: Colors.white,
            currentIndex: _index,
            onTap: (index) {
              if (index != _index) {
                _navigationQueue.removeWhere((element) => element == index);
                _navigationQueue.addLast(index);
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
