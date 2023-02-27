import 'dart:convert';
import 'package:egas_delivery/common/colors.dart';
import 'package:egas_delivery/widgets/custom_appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'login_screen.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final _baseUrl = "${apiLink}products";

  int _page = 0;

  final int _limit = 10;

  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;

  bool _isLoadMoreRunning = false;

  List _posts = [];

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });

      _page += 1; // Increase _page by 1

      try {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        var custId = preferences.getString("custId");
        final res = await http.post(
          Uri.parse(_baseUrl),
          body: {
            "cust_id": "1",
            "cat_id": catId[current].toString(),
            "from": _page.toString(),
            "limit": _limit.toString()
          },
        );

        if (res.statusCode == 200) {
          final List fetchedPosts = json.decode(res.body)['products'];
          if (fetchedPosts.isNotEmpty) {
            setState(
              () {
                _posts = _posts + fetchedPosts;
              },
            );
          } else {
            setState(() {
              _hasNextPage = false;
            });
          }
        } else {
          throw Exception('Unexpected error occured!');
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(
        () {
          _isLoadMoreRunning = false;
        },
      );
    }
  }

  void _firstLoad() async {
    setState(
      () {
        _isFirstLoadRunning = true;
      },
    );

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var custId = preferences.getString("custId");
      final res = await http.post(
        Uri.parse(_baseUrl),
        body: {
          "cust_id": "1",
          "cat_id": catId[current].toString(),
          "from": _page.toString(),
          "limit": _limit.toString()
        },
      );
      String jsonsDataString = res.body
          .toString(); // toString of Response's body is assigned to jsonDataString
      // ignore: no_leading_underscores_for_local_identifiers
      var _data = jsonDecode(jsonsDataString);
      // ignore: avoid_print
      print(_data.toString());
      if (res.statusCode == 200) {
        setState(() {
          _posts = json.decode(res.body)['products'];
        });
      } else {
        throw Exception('Unexpected error occured!');
      }
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  late ScrollController _controller;

  List<String> items = ["Products", "Services"];

  /// List of orders status
  List<String> catId = ["1", "2"];
  int current = 0;
  bool shouldPop = true;

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        setState(() {
          Navigator.pop(context, true);
        });
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: CustomAppBar(
          appbarText: "Products",
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, true),
          ),
          action: [
            IconButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove("supplierCode");
                prefs.remove("name");
                prefs.remove("mobileNumber");
                prefs.remove("groupId");
                prefs.remove("dbId");
                prefs.remove("email");
                // ignore: use_build_context_synchronously
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const LoginScreen();
                    },
                  ),
                  (_) => false,
                );
              },
              icon: const Icon(Icons.logout_sharp),
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                width: double.infinity,
                height: 65,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                _page = 0;
                                _firstLoad();
                                current = index;
                              },
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.42,
                            height: 45,
                            decoration: BoxDecoration(
                              color: current == index ? kPrimaryColor : null,
                              borderRadius: current == index
                                  ? BorderRadius.circular(10)
                                  : BorderRadius.circular(10),
                              border: current == index
                                  ? null
                                  : Border.all(color: Colors.black26, width: 1),
                            ),
                            child: Center(
                              child: Text(
                                items[index],
                                style: TextStyle(
                                    color: current == index
                                        ? Colors.white
                                        : Colors.black26,
                                    fontSize: 17),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Expanded(
                child: Container(
                  child: _isFirstLoadRunning
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: Center(
                                child: Builder(
                                  builder: (context) {
                                    return GridView.builder(
                                      itemCount: _posts.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  MediaQuery.of(context)
                                                              .orientation ==
                                                          Orientation.landscape
                                                      ? 3
                                                      : 2,
                                              crossAxisSpacing: 8,
                                              mainAxisSpacing: 8,
                                              childAspectRatio:
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.42 /
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      3.72),
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          elevation: 1,
                                          child: Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.015,
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.18,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.29,
                                                  child: Image.network(
                                                    _posts[index]
                                                        ['product_image'],
                                                    fit: BoxFit.scaleDown,
                                                    height: double.infinity,
                                                    width: double.infinity,
                                                    alignment: Alignment.center,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.005,
                                                ),
                                                Text(
                                                  _posts[index]['product_name'],
                                                  style: const TextStyle(
                                                      color: Colors.black38),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                          '₹${_posts[index]['amount']}',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.001,
                                                        ),
                                                        Text(
                                                          '₹${_posts[index]['amount']}',
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .black38,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough),
                                                        ),
                                                      ],
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.055,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.12,
                                                        child: ElevatedButton(
                                                          onPressed: () async {
                                                            final proId = _posts[
                                                                    index]
                                                                ['product_id'];
                                                            final orderAmount =
                                                                _posts[index]
                                                                    ['amount'];
                                                            // ignore: unused_local_variable
                                                            final user = additem(
                                                                proId,
                                                                orderAmount);
                                                            Fluttertoast
                                                                .showToast(
                                                              msg:
                                                                  "Item added successfully",
                                                              toastLength: Toast
                                                                  .LENGTH_LONG,
                                                              gravity:
                                                                  ToastGravity
                                                                      .BOTTOM,
                                                              timeInSecForIosWeb:
                                                                  1,
                                                              backgroundColor:
                                                                  Colors.green,
                                                              textColor:
                                                                  Colors.white,
                                                            );
                                                          },
                                                          style: ButtonStyle(
                                                            shape: MaterialStateProperty
                                                                .all<
                                                                    RoundedRectangleBorder>(
                                                              const RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          15),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          15),
                                                                ),
                                                              ),
                                                            ),
                                                            backgroundColor:
                                                                const MaterialStatePropertyAll<
                                                                        Color>(
                                                                    kPrimaryColor),
                                                          ),
                                                          child: const Icon(
                                                            Icons
                                                                .shopping_cart_outlined,
                                                            color: Colors.white,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            if (_isLoadMoreRunning == true)
                              const Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 40),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> additem(String proId, String orderAmount) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var dbId = preferences.getString("dbId");
    var orderId = preferences.getString("orderId");
    const String apiUrl = "${apiLink}addNewOrderItem";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        {
          "db_id": dbId,
          "order_id": orderId,
          "product_id": proId,
          "qty": "1",
          "price": orderAmount
        },
      ),
    );
    String jsonsDataString = response.body
        .toString(); // toString of Response's body is assigned to jsonDataString
    // ignore: no_leading_underscores_for_local_identifiers
    var _data = jsonDecode(jsonsDataString);
// ignore: avoid_print
    print(_data.toString());
    if (response.statusCode == 200) {
      return true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update album.');
    }
  }
}

savePref(String productId) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString("productId", productId);
  // ignore: deprecated_member_use
  preferences.commit();
}
