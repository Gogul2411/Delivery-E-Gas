import 'dart:convert';
import 'package:egas_delivery/common/colors.dart';
import 'package:egas_delivery/model_files/order_details_model.dart';
import 'package:egas_delivery/screens/login_screen.dart';
import 'package:egas_delivery/widgets/custom_appbar.dart';
import 'package:egas_delivery/widgets/custom_button.dart';
import 'package:egas_delivery/widgets/custom_form.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<OrderDetailsModel> ordersList() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var orderId = preferences.getString("orderId");
  const String apiUrl = "${apiLink}getOrderDetails";
  final response =
      await http.post(Uri.parse(apiUrl), body: {"ord_id": orderId});
  String jsonsDataString = response.body
      .toString(); // toString of Response's body is assigned to jsonDataString
  // ignore: no_leading_underscores_for_local_identifiers
  var _data = jsonDecode(jsonsDataString);
  // ignore: avoid_print
  print(_data.toString());
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return OrderDetailsModel.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  TextEditingController notesController = TextEditingController();
  late Future<OrderDetailsModel> productData;
  late Future<List<OrderItem>> _orderItem;
  FocusNode focusNode = FocusNode();
  String? orderStatus;
  String? paymentMode;
  String? orderNotes;

  @override
  void initState() {
    super.initState();
    getPref();
    productData = ordersList();
    _orderItem = orderItem();
    notesController = TextEditingController();
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        setState(
          () {
            Navigator.pop(context, true);
          },
        );
        return Future.value(true);
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: CustomAppBar(
            appbarText: "Order Details",
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, true),
            ),
            action: [
              IconButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
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
          resizeToAvoidBottomInset: true,
          body: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                color: kBackground,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Center(
                    child: FutureBuilder<OrderDetailsModel>(
                      future: productData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Color.fromARGB(
                                              255, 223, 223, 223),
                                          blurRadius: 1),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(7),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Order Id",
                                              style: TextStyle(
                                                  color: Colors.black38),
                                            ),
                                            Text(
                                                '#${snapshot.data!.order.orderId}'),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Order Date',
                                              style: TextStyle(
                                                  color: Colors.black38),
                                            ),
                                            Text(
                                              snapshot.data!.order.createdOn,
                                              style: const TextStyle(
                                                  color: Colors.black38),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Divider(
                                            thickness: 1,
                                            color: Color.fromARGB(
                                                255, 241, 241, 241),
                                            height: 2),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          children: [
                                            const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Delivery Address',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                snapshot
                                                    .data!.address.customerName,
                                                style: const TextStyle(
                                                  color: Colors.black38,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                snapshot.data!.address.address,
                                                style: const TextStyle(
                                                    color: Colors.black38),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Mobile Number',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                snapshot
                                                    .data!.order.customerMobile,
                                                style: const TextStyle(
                                                    color: Colors.black38),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Color.fromARGB(
                                              255, 223, 223, 223),
                                          blurRadius: 1),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 50,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              topRight: Radius.circular(5)),
                                          color: Color.fromARGB(
                                              255, 213, 236, 255),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 8, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Text(
                                                'Items',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              Text(
                                                'Total',
                                                style: TextStyle(fontSize: 16),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: FutureBuilder<List<OrderItem>>(
                                          future: _orderItem,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              List<OrderItem>? data =
                                                  snapshot.data;
                                              return ListView.separated(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: data!.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(8, 5, 8, 5),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(data[index]
                                                            .productName),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              '₹ ${data[index].cost} x ${data[index].quantity}',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black38),
                                                            ),
                                                            Text(
                                                                '₹ ${data[index].totalAmount}'),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const Divider(
                                                      thickness: 1.5,
                                                      color: Color.fromARGB(
                                                          255, 241, 241, 241),
                                                      height: 1);
                                                },
                                              );
                                            } else if (snapshot.hasError) {
                                              return Text("${snapshot.error}");
                                            }
                                            // By default show a loading spinner.
                                            return const Center();
                                          },
                                        ),
                                      ),
                                      const Divider(
                                          thickness: 1.5,
                                          color: Color.fromARGB(
                                              255, 241, 241, 241),
                                          height: 1),
                                      /*Builder(
                                        builder: (context) {
                                          return snapshot.data!.order
                                                          .statusLabel !=
                                                      'Delivered' &&
                                                  snapshot.data!.order
                                                          .statusLabel !=
                                                      'Cancelled'
                                              ? Align(
                                                  alignment: Alignment.topLeft,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      final custId = snapshot
                                                          .data!.order.custId;
                                                      // ignore: unused_local_variable
                                                      final user =
                                                          savePref(custId);
                                                      Navigator.of(context)
                                                          .push(
                                                            MaterialPageRoute(
                                                              builder: (_) =>
                                                                  const Products(),
                                                            ),
                                                          )
                                                          .then((val) => val
                                                              ? setState(
                                                                  () {
                                                                    productData =
                                                                        ordersList();
                                                                    _orderItem =
                                                                        orderItem();
                                                                  },
                                                                )
                                                              : null);
                                                    },
                                                    style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          kPrimaryColor,
                                                    ),
                                                    child: const Text(
                                                      'Add more items',
                                                      style: TextStyle(
                                                          fontSize: 13),
                                                    ),
                                                  ),
                                                )
                                              : const Center();
                                        },
                                      ),*/
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Color.fromARGB(
                                              255, 223, 223, 223),
                                          blurRadius: 1),
                                    ],
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Order Status',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 40,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemCount: snapshot
                                                .data!.orderStatus.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Row(
                                                children: <Widget>[
                                                  Radio(
                                                    visualDensity: const VisualDensity(
                                                        horizontal:
                                                            VisualDensity
                                                                .minimumDensity,
                                                        vertical: VisualDensity
                                                            .minimumDensity),
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    value: index.toString(),
                                                    groupValue: orderStatus,
                                                    activeColor: kPrimaryColor,
                                                    onChanged: (val) {
                                                      setState(
                                                        () {
                                                          orderStatus = val;
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    snapshot.data!
                                                        .orderStatus[index],
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Divider(
                                            thickness: 1.5,
                                            color: Color.fromARGB(
                                                255, 241, 241, 241),
                                            height: 1),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Payment Mode',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 40,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemCount: snapshot
                                                .data!.paymentMode.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Row(
                                                children: <Widget>[
                                                  Radio(
                                                    value: index.toString(),
                                                    groupValue: paymentMode,
                                                    activeColor: kPrimaryColor,
                                                    visualDensity: const VisualDensity(
                                                        horizontal:
                                                            VisualDensity
                                                                .minimumDensity,
                                                        vertical: VisualDensity
                                                            .minimumDensity),
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        paymentMode = val;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    snapshot.data!
                                                        .paymentMode[index],
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Divider(
                                            thickness: 1.5,
                                            color: Color.fromARGB(
                                                255, 241, 241, 241),
                                            height: 1),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Order Notes',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        CustomForm(
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxlines: 4,
                                            myFocusNode: focusNode,
                                            initial:
                                                snapshot.data!.order.orderNotes,
                                            hintTxt: 'Notes',
                                            onChanged: (value) {
                                              orderNotes = value;
                                            },
                                            checkValidator: null,
                                            obscureTxt: false),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 206,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(255, 223, 223, 223), blurRadius: 3),
              ],
            ),
            child: Center(
              child: FutureBuilder<OrderDetailsModel>(
                future: productData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Subtotal",
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text('₹ ${snapshot.data!.order.subtotal}')
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Tax & Fees",
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text('₹ ${snapshot.data!.order.tax}')
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Delivery",
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text('₹ ${snapshot.data!.order.deliveryCharge}')
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total",
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text('₹ ${snapshot.data!.order.totalAmount}')
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(
                                thickness: 2,
                                color: Color.fromARGB(255, 241, 241, 241),
                                height: 1),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 55,
                              width: double.infinity,
                              child: CustomButton(
                                buttonText: "Update Order",
                                onPressed: () {
                                  final String ordStatus =
                                      orderStatus.toString();
                                  final String payStatus =
                                      paymentMode.toString();
                                  final String notes = orderNotes.toString();
                                  // ignore: unused_local_variable
                                  final user = updateOrder(
                                    notes,
                                    ordStatus,
                                    payStatus,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                  }
                  return const Center();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(
      () {
        orderStatus = preferences.getString("statusLabel");
        paymentMode = preferences.getString("paymentLabel");
      },
    );
  }

  Future<bool> updateOrder(
      String notes, String ordStatus, String payStatus) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var orderId = preferences.getString("orderId");
    const String apiUrl = "${apiLink}updateOrder";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        {
          "order_id": orderId,
          "order_status": ordStatus,
          "payment_mode": payStatus,
          "order_notes": notes
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
      setState(() {});
      productData = ordersList();
      _orderItem = orderItem();
      setState(() {});
      return true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update album.');
    }
  }
}

Future<List<OrderItem>> orderItem() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var orderId = preferences.getString("orderId");
  const String apiUrl = "${apiLink}getorderDetails";
  final response =
      await http.post(Uri.parse(apiUrl), body: {"ord_id": orderId});
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body)['orderItems'];
    String jsonsDataString = response.body
        .toString(); // toString of Response's body is assigned to jsonDataString
    // ignore: no_leading_underscores_for_local_identifiers
    var _data = jsonDecode(jsonsDataString);
    // ignore: avoid_print
    print(_data.toString());
    return jsonResponse.map((order) => OrderItem.fromJson(order)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

savePref(String custId) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString("custId", custId);
  // ignore: deprecated_member_use
  preferences.commit();
}
