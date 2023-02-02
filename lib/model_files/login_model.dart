// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    required this.dbId,
    required this.groupId,
    required this.supplierCode,
    required this.name,
    required this.mobileNumber,
    required this.email,
    required this.status,
  });

  String dbId;
  String groupId;
  String supplierCode;
  String name;
  String mobileNumber;
  String email;
  String status;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        dbId: json["db_id"],
        groupId: json["group_id"],
        supplierCode: json["supplier_code"],
        name: json["name"],
        mobileNumber: json["mobile_number"],
        email: json["email"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "db_id": dbId,
        "group_id": groupId,
        "supplier_code": supplierCode,
        "name": name,
        "mobile_number": mobileNumber,
        "email": email,
        "status": status,
      };
}
