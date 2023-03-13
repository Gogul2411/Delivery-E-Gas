import 'dart:convert';
import 'package:egas_delivery/common/colors.dart';
import 'package:egas_delivery/model_files/dashboard_model.dart';
import 'package:egas_delivery/screens/order_details.dart';
import 'package:egas_delivery/widgets/custom_appbar.dart';
import 'package:egas_delivery/widgets/custom_container.dart';
import 'package:egas_delivery/widgets/logout.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<List<Order>> futureData;
  late Future<DashboardModel> dashList;

  @override
  void initState() {
    super.initState();
    futureData = ordersList();
    dashList = data();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double width = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar(
        appbarText: "Dashboard",
        action: const [
          logout(),
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: FutureBuilder<DashboardModel>(
            future: dashList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Container(
                    height: double.infinity,
                    color: kBackground,
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromARGB(255, 223, 223, 223),
                                      blurRadius: 1),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        DashContainer(
                                          containerColor: const Color.fromARGB(
                                              255, 227, 252, 246),
                                          iconData: const Icon(
                                            Icons.check_circle_outline_outlined,
                                            color: Color(0xFF27d7af),
                                          ),
                                          statusText: "Complete Delivery",
                                          countText: snapshot.data!.delivered
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                        ),
                                        DashContainer(
                                          containerColor: const Color.fromARGB(
                                              237, 253, 248, 232),
                                          iconData: const Icon(
                                            Icons.pending_actions,
                                            color: Color(0xFFdfbb41),
                                          ),
                                          statusText: "Pending Delivery",
                                          countText:
                                              snapshot.data!.pending.toString(),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.017,
                                    ),
                                    Row(
                                      children: [
                                        DashContainer(
                                          containerColor: const Color.fromARGB(
                                              255, 253, 230, 238),
                                          iconData: const Icon(
                                            Icons.cancel_outlined,
                                            color: Color(0xFFf03e7a),
                                          ),
                                          statusText: "Cancel Delivery",
                                          countText: snapshot.data!.cancelled
                                              .toString(),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                        ),
                                        DashContainer(
                                          containerColor: const Color.fromARGB(
                                              255, 228, 243, 255),
                                          iconData: const Icon(
                                            Icons.input_outlined,
                                            color: Color(0xFF5ba0db),
                                          ),
                                          statusText: "Collections",
                                          countText: snapshot.data!.collection
                                              .toString(),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Recent Orders",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 165,
                                child: Center(
                                  child: FutureBuilder<List<Order>>(
                                    future: futureData,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        List<Order>? data = snapshot.data;
                                        return data!.isNotEmpty
                                            ? ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                itemCount: data.length,
                                                shrinkWrap: true,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Column(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors.white,
                                                          boxShadow: const [
                                                            BoxShadow(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        223,
                                                                        223,
                                                                        223),
                                                                blurRadius: 1),
                                                          ],
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                height: 100,
                                                                width: 100,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child: Image
                                                                      .network(
                                                                    data[index]
                                                                        .image,
                                                                    fit: BoxFit
                                                                        .scaleDown,
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
                                                                width: 20,
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 2,
                                                                  ),
                                                                  Text(
                                                                      'ORDER : #${data[index].orderId.toString()}'),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      const Icon(
                                                                        Icons
                                                                            .location_on_outlined,
                                                                        color:
                                                                            kPrimaryColor,
                                                                        size:
                                                                            15,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            190,
                                                                        child:
                                                                            Text(
                                                                          data[index]
                                                                              .address
                                                                              .toString()
                                                                              .replaceAll("\n", " "),
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: const TextStyle(
                                                                              fontSize: 12,
                                                                              color: Colors.black54),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      const Icon(
                                                                        Icons
                                                                            .watch_later_outlined,
                                                                        color:
                                                                            kPrimaryColor,
                                                                        size:
                                                                            15,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            7,
                                                                      ),
                                                                      Text(
                                                                        data[index]
                                                                            .createdOn,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                Colors.black54),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  SizedBox(
                                                                    height: 30,
                                                                    width: 90,
                                                                    child:
                                                                        ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                        final orderId =
                                                                            data[index].ordId;
                                                                        final orderStatus =
                                                                            data[index].orderStatus;
                                                                        final paymentMode =
                                                                            data[index].paymentMode;
                                                                        //final orderStatus = data[index].ordId;
                                                                        // ignore: unused_local_variable
                                                                        final user = savePref(
                                                                            orderId,
                                                                            orderStatus,
                                                                            paymentMode);
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                const OrderDetails(),
                                                                          ),
                                                                        );
                                                                      },
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor:
                                                                            Colors.green,
                                                                        padding:
                                                                            EdgeInsets.zero,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5.0),
                                                                        ),
                                                                      ),
                                                                      child: const Text(
                                                                          "View Details",
                                                                          textAlign:
                                                                              TextAlign.center),
                                                                    ),
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
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.15,
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01,
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
                                      } else if (snapshot.hasError) {
                                        return Text("${snapshot.error}");
                                      }
                                      // By default show a loading spinner.
                                      return const CircularProgressIndicator();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
    );
  }
}

Future<List<Order>> ordersList() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var deliveryboyId = preferences.getString("dbId");
  const String apiUrl = "${apiLink}dashboardDB";
  final response = await http.post(
    Uri.parse(apiUrl),
    body: {"db_id": deliveryboyId, "type": "This Month"},
  );
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body)['orders'];
    String jsonsDataString = response.body
        .toString(); // toString of Response's body is assigned to jsonDataString
    // ignore: no_leading_underscores_for_local_identifiers
    var _data = jsonDecode(jsonsDataString);
    // ignore: avoid_print
    print(_data.toString());
    return jsonResponse.map((orders) => Order.fromJson(orders)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

Future<DashboardModel> data() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var deliveryboyId = preferences.getString("dbId");
  const String apiUrl = "${apiLink}dashboardDB";
  final response = await http.post(
    Uri.parse(apiUrl),
    body: {"db_id": deliveryboyId, "type": "This Month"},
  );
  String jsonsDataString = response.body
      .toString(); // toString of Response's body is assigned to jsonDataString
  // ignore: no_leading_underscores_for_local_identifiers
  var _data = jsonDecode(jsonsDataString);
  // ignore: avoid_print
  print(_data.toString());
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return DashboardModel.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

savePref(String orderId, String orderStatus, String paymentMode) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString("orderId", orderId);
  preferences.setString("orderStatus", orderStatus);
  preferences.setString("paymentMode", paymentMode);
  // ignore: deprecated_member_use
  preferences.commit();
}
