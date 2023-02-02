// To parse this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString);

import 'dart:convert';

DashboardModel dashboardModelFromJson(String str) =>
    DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  DashboardModel({
    required this.deliveryboy,
    required this.collection,
    required this.delivered,
    required this.pending,
    required this.cancelled,
    required this.orders,
  });

  Deliveryboy deliveryboy;
  int collection;
  int delivered;
  int pending;
  int cancelled;
  List<Order> orders;

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        deliveryboy: Deliveryboy.fromJson(json["deliveryboy"]),
        collection: json["collection"],
        delivered: json["delivered"],
        pending: json["pending"],
        cancelled: json["cancelled"],
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "deliveryboy": deliveryboy.toJson(),
        "collection": collection,
        "delivered": delivered,
        "pending": pending,
        "cancelled": cancelled,
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class Deliveryboy {
  Deliveryboy({
    required this.supplierCode,
    required this.name,
  });

  String supplierCode;
  String name;

  factory Deliveryboy.fromJson(Map<String, dynamic> json) => Deliveryboy(
        supplierCode: json["supplier_code"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "supplier_code": supplierCode,
        "name": name,
      };
}

class Order {
  Order({
    required this.ordId,
    required this.address,
    required this.orderId,
    required this.custName,
    required this.totalAmount,
    required this.timeSlot,
    required this.createdOn,
    required this.orderStatus,
    required this.statusLabel,
    required this.statusColor,
  });

  String ordId;
  String address;
  String orderId;
  String custName;
  String totalAmount;
  String timeSlot;
  String createdOn;
  String orderStatus;
  String statusLabel;
  String statusColor;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        ordId: json["ord_id"],
        address: json["address"],
        orderId: json["order_id"],
        custName: json["cust_name"],
        totalAmount: json["total_amount"],
        timeSlot: json["time_slot"],
        createdOn: json["created_on"],
        orderStatus: json["order_status"],
        statusLabel: json["status_label"],
        statusColor: json["status_color"],
      );

  Map<String, dynamic> toJson() => {
        "ord_id": ordId,
        "address": address,
        "order_id": orderId,
        "cust_name": custName,
        "total_amount": totalAmount,
        "time_slot": timeSlot,
        "created_on": createdOn,
        "order_status": orderStatus,
        "status_label": statusLabel,
        "status_color": statusColor,
      };
}
