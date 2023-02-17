// To parse this JSON data, do
//
//     final getProfileModel = getProfileModelFromJson(jsonString);

import 'dart:convert';

GetProfileModel getProfileModelFromJson(String str) => GetProfileModel.fromJson(json.decode(str));

String getProfileModelToJson(GetProfileModel data) => json.encode(data.toJson());

class GetProfileModel {
    GetProfileModel({
        required this.id,
        required this.groupId,
        required this.supplierCode,
        required this.name,
        required this.mobileNumber,
        required this.email,
        required this.supplierName,
        required this.group,
    });

    String id;
    String groupId;
    String supplierCode;
    String name;
    String mobileNumber;
    String email;
    String supplierName;
    List<Group> group;

    factory GetProfileModel.fromJson(Map<String, dynamic> json) => GetProfileModel(
        id: json["id"],
        groupId: json["group_id"],
        supplierCode: json["supplier_code"],
        name: json["name"],
        mobileNumber: json["mobile_number"],
        email: json["email"],
        supplierName: json["supplier_name"],
        group: List<Group>.from(json["group"].map((x) => Group.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "group_id": groupId,
        "supplier_code": supplierCode,
        "name": name,
        "mobile_number": mobileNumber,
        "email": email,
        "supplier_name": supplierName,
        "group": List<dynamic>.from(group.map((x) => x.toJson())),
    };
}

class Group {
    Group({
        required this.groupId,
        required this.customersGroup,
    });

    String groupId;
    String customersGroup;

    factory Group.fromJson(Map<String, dynamic> json) => Group(
        groupId: json["group_id"],
        customersGroup: json["customers_group"],
    );

    Map<String, dynamic> toJson() => {
        "group_id": groupId,
        "customers_group": customersGroup,
    };
}
