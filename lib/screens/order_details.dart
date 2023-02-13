import 'dart:convert';
import 'package:egas_delivery/common/colors.dart';
import 'package:egas_delivery/widgets/custom_appbar.dart';
import 'package:egas_delivery/widgets/custom_button.dart';
import 'package:egas_delivery/widgets/custom_form.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    required this.paymentMode,
    required this.orderStatus,
    required this.order,
    required this.supplier,
    required this.address,
    required this.orderItems,
  });

  List<String> paymentMode;
  List<String> orderStatus;
  OrderClass order;
  Supplier supplier;
  Address address;
  List<OrderItem> orderItems;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        paymentMode: List<String>.from(json["payment_mode"].map((x) => x)),
        orderStatus: List<String>.from(json["order_status"].map((x) => x)),
        order: OrderClass.fromJson(json["order"]),
        supplier: Supplier.fromJson(json["supplier"]),
        address: Address.fromJson(json["address"]),
        orderItems: List<OrderItem>.from(
            json["orderItems"].map((x) => OrderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "payment_mode": List<dynamic>.from(paymentMode.map((x) => x)),
        "order_status": List<dynamic>.from(orderStatus.map((x) => x)),
        "order": order.toJson(),
        "supplier": supplier.toJson(),
        "address": address.toJson(),
        "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
      };
}

class Address {
  Address({
    required this.customerName,
    required this.mobileNumber,
    required this.addressId,
    required this.address,
  });

  String customerName;
  String mobileNumber;
  String addressId;
  String address;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        customerName: json["customer_name"],
        mobileNumber: json["mobile_number"],
        addressId: json["address_id"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "customer_name": customerName,
        "mobile_number": mobileNumber,
        "address_id": addressId,
        "address": address,
      };
}

class OrderClass {
  OrderClass({
    required this.ordId,
    required this.orderId,
    required this.custId,
    required this.customerName,
    required this.customerMobile,
    required this.totalAmount,
    required this.paidAmount,
    required this.createdOn,
    required this.supplierCode,
    required this.paymentMode,
    required this.orderNotes,
    required this.orderStatus,
    required this.reason,
    required this.statusLabel,
    required this.paymentLabel,
    required this.subtotal,
    required this.tax,
    required this.deliveryCharge,
  });

  String ordId;
  String orderId;
  String custId;
  String customerName;
  String customerMobile;
  String totalAmount;
  String paidAmount;
  String createdOn;
  String supplierCode;
  String paymentMode;
  String orderNotes;
  String orderStatus;
  String reason;
  String statusLabel;
  String paymentLabel;
  String subtotal;
  int tax;
  int deliveryCharge;

  factory OrderClass.fromJson(Map<String, dynamic> json) => OrderClass(
        ordId: json["ord_id"],
        orderId: json["order_id"],
        custId: json["cust_id"],
        customerName: json["customer_name"],
        customerMobile: json["customer_mobile"],
        totalAmount: json["total_amount"],
        paidAmount: json["paid_amount"],
        createdOn: json["created_on"],
        supplierCode: json["supplier_code"],
        paymentMode: json["payment_mode"],
        orderNotes: json["order_notes"],
        orderStatus: json["order_status"],
        reason: json["reason"],
        statusLabel: json["status_label"],
        paymentLabel: json["payment_label"],
        subtotal: json["subtotal"],
        tax: json["tax"],
        deliveryCharge: json["delivery_charge"],
      );

  Map<String, dynamic> toJson() => {
        "ord_id": ordId,
        "order_id": orderId,
        "cust_id": custId,
        "customer_name": customerName,
        "customer_mobile": customerMobile,
        "total_amount": totalAmount,
        "paid_amount": paidAmount,
        "created_on": createdOn,
        "supplier_code": supplierCode,
        "payment_mode": paymentMode,
        "order_notes": orderNotes,
        "order_status": orderStatus,
        "reason": reason,
        "status_label": statusLabel,
        "payment_label": paymentLabel,
        "subtotal": subtotal,
        "tax": tax,
        "delivery_charge": deliveryCharge,
      };
}

class OrderItem {
  OrderItem({
    required this.orderItemId,
    required this.productName,
    required this.weight,
    required this.quantity,
    required this.cost,
    required this.totalAmount,
  });

  String orderItemId;
  String productName;
  String weight;
  String quantity;
  String cost;
  String totalAmount;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        orderItemId: json["order_item_id"],
        productName: json["product_name"],
        weight: json["weight"],
        quantity: json["quantity"],
        cost: json["cost"],
        totalAmount: json["total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "order_item_id": orderItemId,
        "product_name": productName,
        "weight": weight,
        "quantity": quantity,
        "cost": cost,
        "total_amount": totalAmount,
      };
}

class Supplier {
  Supplier({
    required this.supplierCode,
    required this.supplierName,
    required this.email,
    required this.mobileNumber,
    required this.gstNumber,
    required this.supplierLogo,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.pincode,
  });

  String supplierCode;
  String supplierName;
  String email;
  String mobileNumber;
  String gstNumber;
  String supplierLogo;
  String addressLine1;
  String addressLine2;
  String city;
  String pincode;

  factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
        supplierCode: json["supplier_code"],
        supplierName: json["supplier_name"],
        email: json["email"],
        mobileNumber: json["mobile_number"],
        gstNumber: json["gst_number"],
        supplierLogo: json["supplier_logo"],
        addressLine1: json["address_line1"],
        addressLine2: json["address_line2"],
        city: json["city"],
        pincode: json["pincode"],
      );

  Map<String, dynamic> toJson() => {
        "supplier_code": supplierCode,
        "supplier_name": supplierName,
        "email": email,
        "mobile_number": mobileNumber,
        "gst_number": gstNumber,
        "supplier_logo": supplierLogo,
        "address_line1": addressLine1,
        "address_line2": addressLine2,
        "city": city,
        "pincode": pincode,
      };
}

Future<Order> ordersList() async {
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
    return Order.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

enum OrderStat { javatpoint, w3schools, tutorialandexample }

class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  TextEditingController notesController = TextEditingController();
  late Future<Order> productData;
  late Future<List<OrderItem>> _orderItem;
  FocusNode myFocusNode = FocusNode();
  String? orderStatus;
  String? paymentMode;

  @override
  void initState() {
    super.initState();
    productData = ordersList();
    _orderItem = orderItem();
    notesController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(appbarText: "Order Details"),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            color: kBackground,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Center(
                child: FutureBuilder<Order>(
                  future: productData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        orderStatus = snapshot.data!.order.statusLabel;
                        paymentMode = snapshot.data!.order.paymentLabel;
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
                                              fontSize: 15,
                                              color: Colors.black38),
                                        ),
                                        Text(
                                          '#${snapshot.data!.order.orderId}',
                                          style: const TextStyle(fontSize: 15),
                                        ),
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
                                              fontSize: 15,
                                              color: Colors.black38),
                                        ),
                                        Text(
                                          snapshot.data!.order.createdOn,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black38),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Divider(
                                        thickness: 1,
                                        color:
                                            Color.fromARGB(255, 241, 241, 241),
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
                                            snapshot.data!.address.customerName,
                                            style: const TextStyle(
                                              color: Colors.black38,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            snapshot.data!.address.address,
                                            style: const TextStyle(
                                                fontSize: 13,
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
                                            snapshot.data!.order.customerMobile,
                                            style: const TextStyle(
                                                fontSize: 13,
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
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          topRight: Radius.circular(5)),
                                      color: Color.fromARGB(255, 213, 236, 255),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text(
                                            'Items',
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          Text(
                                            'Total',
                                            style: TextStyle(fontSize: 17),
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
                                          List<OrderItem>? data = snapshot.data;
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: data!.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 5, 8, 5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data[index].productName,
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                    ),
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
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black38,
                                                                  fontSize: 13),
                                                        ),
                                                        Text(
                                                          '₹ ${data[index].totalAmount}',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black38,
                                                                  fontSize: 13),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    const Divider(
                                                        thickness: 1.5,
                                                        color: Color.fromARGB(
                                                            255, 241, 241, 241),
                                                        height: 1),
                                                  ],
                                                ),
                                              );
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
                                  // Align(
                                  //   alignment: Alignment.topLeft,
                                  //   child: TextButton(
                                  //     onPressed: () {
                                  //       final custId =
                                  //           snapshot.data!.order.custId;
                                  //       // ignore: unused_local_variable
                                  //       final user = savePref(custId);
                                  //       Navigator.of(context)
                                  //           .push(
                                  //             MaterialPageRoute(
                                  //                 builder: (_) =>
                                  //                     const Products()),
                                  //           )
                                  //           .then((val) => val
                                  //               ? setState(
                                  //                   () {
                                  //                     productData =
                                  //                         ordersList();
                                  //                     _orderItem = orderItem();
                                  //                   },
                                  //                 )
                                  //               : null);
                                  //     },
                                  //     style: TextButton.styleFrom(
                                  //       foregroundColor: kPrimaryColor,
                                  //     ),
                                  //     child: const Text(
                                  //       'Add more items',
                                  //       style: TextStyle(fontSize: 13),
                                  //     ),
                                  //   ),
                                  // ),
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
                                        physics: const BouncingScrollPhysics(),
                                        itemCount:
                                            snapshot.data!.orderStatus.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Row(
                                            children: <Widget>[
                                              Radio(
                                                visualDensity:
                                                    const VisualDensity(
                                                        horizontal:
                                                            VisualDensity
                                                                .minimumDensity,
                                                        vertical: VisualDensity
                                                            .minimumDensity),
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                value: snapshot
                                                    .data!.orderStatus[index],
                                                groupValue: orderStatus,
                                                activeColor: kPrimaryColor,
                                                onChanged: (value) {
                                                  setState(
                                                    () {
                                                      orderStatus = value;
                                                      print(orderStatus);
                                                    },
                                                  );
                                                },
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                snapshot
                                                    .data!.orderStatus[index],
                                                style: const TextStyle(
                                                    fontSize: 13),
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
                                        color:
                                            Color.fromARGB(255, 241, 241, 241),
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
                                        physics: const BouncingScrollPhysics(),
                                        itemCount:
                                            snapshot.data!.paymentMode.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Row(
                                            children: <Widget>[
                                              Radio(
                                                value: snapshot
                                                    .data!.paymentMode[index],
                                                groupValue: paymentMode,
                                                activeColor: kPrimaryColor,
                                                visualDensity:
                                                    const VisualDensity(
                                                        horizontal:
                                                            VisualDensity
                                                                .minimumDensity,
                                                        vertical: VisualDensity
                                                            .minimumDensity),
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                onChanged: (value) {
                                                  setState(() {
                                                    paymentMode = value;
                                                    print(paymentMode);
                                                  });
                                                },
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                snapshot
                                                    .data!.paymentMode[index],
                                                style: const TextStyle(
                                                    fontSize: 13),
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
                                        color:
                                            Color.fromARGB(255, 241, 241, 241),
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
                                        hintTxt: "Order Notes",
                                        maxlines: 4,
                                        keyboardType: TextInputType.multiline,
                                        myFocusNode: myFocusNode,
                                        txtController: notesController,
                                        checkValidator: null,
                                        obscureTxt: false),
                                  ],
                                ),
                              ),
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
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        color: Colors.white,
        height: 206,
        child: Center(
          child: FutureBuilder<Order>(
            future: productData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Column(
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
                            print(orderStatus);
                            print(paymentMode);
                          },
                        ),
                      ),
                    ],
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
    );
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

Future<bool> updateOrder(
    String notes, String ordStatus, String paymentStatus) async {
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
        "payment_mode": paymentStatus,
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
    return true;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to update album.');
  }
}

savePref(String custId) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString("custId", custId);
  // ignore: deprecated_member_use
  preferences.commit();
}
