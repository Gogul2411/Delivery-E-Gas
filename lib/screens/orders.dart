import 'dart:convert';
import 'package:egas_delivery/screens/order_details.dart';
import 'package:http/http.dart' as http;
import 'package:egas_delivery/common/colors.dart';
import 'package:egas_delivery/widgets/custom_appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/logout.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final _baseUrl = "${apiLink}getOrdersDB";

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
        var deliveryboy = preferences.getString("dbId");
        final res = await http.post(
          Uri.parse(_baseUrl),
          body: {
            "db_id": deliveryboy,
            "from": _page.toString(),
            "limit": _limit.toString(),
            "status": status[current].toString()
          },
        );
        if (res.statusCode == 200) {
          final List fetchedPosts = json.decode(res.body)['data'];
          if (fetchedPosts.isNotEmpty) {
            setState(
              () {
                _posts = _posts + fetchedPosts;
              },
            );
          } else {
            setState(
              () {
                _hasNextPage = false;
              },
            );
          }
        } else {
          throw Exception('Unexpected error occured!');
        }
      } catch (err) {
        if (kDebugMode) {
          print('1');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var deliveryboy = preferences.getString("dbId");
      final res = await http.post(
        Uri.parse(_baseUrl),
        body: {
          "db_id": deliveryboy,
          "from": _page.toString(),
          "limit": _limit.toString(),
          "status": status[current].toString()
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
          _posts = json.decode(res.body)['data'];
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

  /// List of Tab Bar Item
  List<String> items = [
    "All Orders",
    "Pendings",
    "Delivered",
    "Cancelled",
  ];

  /// List of orders status
  List<String> status = ["allOrders", "pending", "delivered", "cancelled"];
  int current = 0;

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        setState(
          () {
            Navigator.pop(context, true);
          },
        );
        return Future.value(true);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kBackground,
          appBar: CustomAppBar(
            appbarText: "Orders",
            action: const [
              logout(),
            ],
          ),
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: items.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(
                                () {
                                  current = index;
                                  _page = 0;
                                  _firstLoad();
                                },
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              width: 120,
                              height: 45,
                              decoration: BoxDecoration(
                                color: current == index ? kPrimaryColor : null,
                                borderRadius: current == index
                                    ? BorderRadius.circular(10)
                                    : BorderRadius.circular(10),
                                border: current == index
                                    ? null
                                    : Border.all(
                                        color: Colors.black26, width: 1),
                              ),
                              child: Center(
                                child: Text(
                                  items[index],
                                  style: TextStyle(
                                      color: current == index
                                          ? Colors.white
                                          : Colors.black26),
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
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Builder(
                                      builder: (context) {
                                        return _posts.isNotEmpty
                                            ? ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                itemCount: _posts.length,
                                                controller: _controller,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Column(
                                                    children: [
                                                      InkWell(
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: Colors.white,
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          223,
                                                                          223,
                                                                          223),
                                                                  blurRadius:
                                                                      1),
                                                            ],
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  height: 100,
                                                                  width: 100,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                    child: Image
                                                                        .network(
                                                                      _posts[index]
                                                                          [
                                                                          'image'],
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      height: double
                                                                          .infinity,
                                                                      width: double
                                                                          .infinity,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  height: 120,
                                                                  width: 300,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            300,
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Text(
                                                                                  'ORDER : #${_posts[index]['order_id']}',
                                                                                  style: const TextStyle(fontSize: 16),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Column(
                                                                                  children: [
                                                                                    const SizedBox(
                                                                                      height: 2,
                                                                                    ),
                                                                                    Image.asset(
                                                                                      "assets/icons/inr.png",
                                                                                      height: 11.5,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 1,
                                                                                ),
                                                                                Text(
                                                                                  _posts[index]['total_amount'],
                                                                                  style: const TextStyle(fontSize: 16),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            7,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          const Icon(
                                                                            Icons.location_on_outlined,
                                                                            color:
                                                                                kPrimaryColor,
                                                                            size:
                                                                                15,
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                3,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                280,
                                                                            child:
                                                                                Text(
                                                                              _posts[index]["address"].toString().replaceAll("\n", " "),
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: const TextStyle(fontSize: 15, color: Colors.black54),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            7,
                                                                      ),
                                                                      Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              const Icon(
                                                                                Icons.watch_later_outlined,
                                                                                color: kPrimaryColor,
                                                                                size: 15,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 3,
                                                                              ),
                                                                              Text(
                                                                                _posts[index]['created_on'],
                                                                                style: const TextStyle(fontSize: 15, color: Colors.black54),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            35,
                                                                        width:
                                                                            110,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                          color:
                                                                              const Color(0xFFf7f7f7),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            _posts[index]['status_label'],
                                                                            style: TextStyle(
                                                                                color: HexColor(
                                                                                  _posts[index]['status_color'],
                                                                                ),
                                                                                fontSize: 14),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        onTap: () async {
                                                          final orderId =
                                                              _posts[index]
                                                                  ['ord_id'];
                                                          final orderStatus =
                                                              _posts[index][
                                                                  'status_label'];
                                                          final paymentMode =
                                                              _posts[index][
                                                                  'payment_mode'];
                                                          // ignore: unused_local_variable
                                                          final user = savePref(
                                                              orderId,
                                                              orderStatus,
                                                              paymentMode);
                                                          Navigator.of(context)
                                                              .push(
                                                                MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        const OrderDetails()),
                                                              )
                                                              .then((val) => val
                                                                  ? setState(
                                                                      () {
                                                                        _firstLoad();
                                                                      },
                                                                    )
                                                                  : null);
                                                        },
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  );
                                                },
                                              )
                                            : Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      "assets/images/empty-orders.png",
                                                      width: 250,
                                                    ),
                                                    const SizedBox(
                                                      height: 30,
                                                    ),
                                                    const Text(
                                                      'No Orders Found!',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20),
                                                    ),
                                                  ],
                                                ),
                                              );
                                      },
                                    ),
                                  ),
                                ),
                                if (_isLoadMoreRunning == true)
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 40),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

savePref(String orderId, String orderStatus, String paymentMode) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString("orderId", orderId);
  preferences.setString("statusLabel", orderStatus);
  preferences.setString("paymentLabel", paymentMode);
  // ignore: deprecated_member_use
  preferences.commit();
}
