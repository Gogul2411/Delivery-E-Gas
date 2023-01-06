import 'dart:collection';
import 'package:egas_delivery/common/colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ListQueue<int> _navigationQueue = ListQueue();
  int _index = 0;
  static const List<Widget> _widgetOptions = <Widget>[];

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
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 30),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag, size: 30),
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_sharp, size: 30),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_grocery_store_outlined, size: 30),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined, size: 30),
              label: 'Profile',
            ),
          ],
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: Colors.black45,
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
    );
  }
}