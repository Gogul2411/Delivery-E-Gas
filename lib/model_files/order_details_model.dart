// To parse this JSON data, do
//
//     final orderDetailsModel = orderDetailsModelFromJson(jsonString);

import 'dart:convert';

OrderDetailsModel orderDetailsModelFromJson(String str) => OrderDetailsModel.fromJson(json.decode(str));

String orderDetailsModelToJson(OrderDetailsModel data) => json.encode(data.toJson());

class OrderDetailsModel {
    OrderDetailsModel({
        required this.paymentMode,
        required this.orderStatus,
        required this.order,
        required this.supplier,
        required this.address,
        required this.orderItems,
    });

    List<String> paymentMode;
    List<String> orderStatus;
    Order order;
    Supplier supplier;
    Address address;
    List<OrderItem> orderItems;

    factory OrderDetailsModel.fromJson(Map<String, dynamic> json) => OrderDetailsModel(
        paymentMode: List<String>.from(json["payment_mode"].map((x) => x)),
        orderStatus: List<String>.from(json["order_status"].map((x) => x)),
        order: Order.fromJson(json["order"]),
        supplier: Supplier.fromJson(json["supplier"]),
        address: Address.fromJson(json["address"]),
        orderItems: List<OrderItem>.from(json["orderItems"].map((x) => OrderItem.fromJson(x))),
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

class Order {
    Order({
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

    factory Order.fromJson(Map<String, dynamic> json) => Order(
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
        required this.address,
        required this.city,
    });

    String supplierCode;
    String supplierName;
    String email;
    String mobileNumber;
    String gstNumber;
    String supplierLogo;
    String address;
    String city;

    factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
        supplierCode: json["supplier_code"],
        supplierName: json["supplier_name"],
        email: json["email"],
        mobileNumber: json["mobile_number"],
        gstNumber: json["gst_number"],
        supplierLogo: json["supplier_logo"],
        address: json["address"],
        city: json["city"],
    );

    Map<String, dynamic> toJson() => {
        "supplier_code": supplierCode,
        "supplier_name": supplierName,
        "email": email,
        "mobile_number": mobileNumber,
        "gst_number": gstNumber,
        "supplier_logo": supplierLogo,
        "address": address,
        "city": city,
    };
}
