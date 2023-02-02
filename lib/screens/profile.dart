import 'dart:convert';
import 'package:egas_delivery/common/colors.dart';
import 'package:egas_delivery/screens/login_screen.dart';
import 'package:egas_delivery/widgets/custom_appbar.dart';
import 'package:egas_delivery/widgets/custom_button.dart';
import 'package:egas_delivery/widgets/custom_form.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<GetProfileModel> fetchAlbum() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var deliveryboy = preferences.getString("dbId");
  const String apiUrl = "${apiLink}getProfileDB";
  final response =
      await http.post(Uri.parse(apiUrl), body: {"cust_id": deliveryboy});
  /*String jsonsDataString = response.body
      .toString();
  var apiresbonce = jsonDecode(jsonsDataString);
  print(apiresbonce.toString());*/
  if (response.statusCode == 200) {
    return GetProfileModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController supplierController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late bool passwordVisibility;
  late Future<GetProfileModel> _futureAlbum;
  FocusNode supplierFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();
  FocusNode mobileFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();

  @override
  void initState() {
    _futureAlbum = fetchAlbum();
    supplierController = TextEditingController();
    nameController = TextEditingController();
    mobileController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordVisibility = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar(
          appbarText: "Profile",
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          color: kBackground,
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Center(
                    child: FutureBuilder<GetProfileModel>(
                      future: _futureAlbum,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            return Form(
                              key: _formKey,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    const SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: ProfilePicture(
                                        name: 'Gogul',
                                        radius: 30,
                                        fontsize: 60,
                                        random: true,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    CustomForm(
                                        keyboardType: TextInputType.none,
                                        formEnabled: false,
                                        myFocusNode: supplierFocusNode,
                                        txtController: supplierController,
                                        labelTxt: 'Supplier Name',
                                        hintTxt: 'Supplier Name',
                                        checkValidator: null,
                                        obscureTxt: false),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    CustomForm(
                                        keyboardType: TextInputType.name,
                                        myFocusNode: nameFocusNode,
                                        txtController: nameController,
                                        labelTxt: 'Name',
                                        hintTxt: 'Name',
                                        checkValidator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter name';
                                          } else if (value.length < 3) {
                                            return 'Name should contain more than 3 characters';
                                          } else {
                                            return null;
                                          }
                                        },
                                        obscureTxt: false),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    CustomForm(
                                        keyboardType: TextInputType.phone,
                                        myFocusNode: mobileFocusNode,
                                        txtController: mobileController,
                                        labelTxt: 'Mobile Number',
                                        hintTxt: 'Mobile Number',
                                        checkValidator: (value) {
                                          if (value?.length != 10) {
                                            return 'Please enter a valid mobile number';
                                          } else {
                                            return null;
                                          }
                                        },
                                        obscureTxt: false),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    CustomForm(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        myFocusNode: emailFocusNode,
                                        txtController: emailController,
                                        labelTxt: 'Email',
                                        hintTxt: 'Email',
                                        checkValidator: (value) =>
                                            EmailValidator.validate(value!)
                                                ? null
                                                : "Please enter a valid email",
                                        obscureTxt: false),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    CustomForm(
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureTxt: !passwordVisibility,
                                      myFocusNode: passFocusNode,
                                      txtController: passwordController,
                                      labelTxt: 'Password',
                                      hintTxt: 'Password',
                                      checkValidator: null,
                                      icon: InkWell(
                                        onTap: () => setState(
                                          () => passwordVisibility =
                                              !passwordVisibility,
                                        ),
                                        focusNode:
                                            FocusNode(skipTraversal: true),
                                        child: Icon(
                                          passwordVisibility
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: const Color(0xFF95A1AC),
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 55.0,
                                      child: CustomButton(
                                        buttonText: "Update Profile",
                                        onPressed: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          prefs.remove("mobileNumber");
                                          prefs.remove("companyName");
                                          prefs.remove("userId");
                                          prefs.remove("email");
                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return const LoginScreen();
                                              },
                                            ),
                                            (_) => false,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
  // Future<bool> updateProfile(String mobileNumber, String custName,
  //     String supplierCode, String address, String password) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   var loginStatus = preferences.getString("custId");
  //   const String apiUrl = "${apiLink}createProfile";
  //   final response = await http.post(
  //     Uri.parse(apiUrl),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(
  //       {
  //         "cust_id": loginStatus,
  //         "cust_name": custName,
  //         "mobile_number": mobileNumber,
  //         "address": address,
  //         "password": password
  //       },
  //     ),
  //   );
  //   String jsonsDataString = response.body
  //       .toString(); // toString of Response's body is assigned to jsonDataString
  //   // ignore: no_leading_underscores_for_local_identifiers
  //   var _data = jsonDecode(jsonsDataString);
  //   print(_data.toString());
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       // ignore: unused_local_variable
  //       final user = savePref(
  //         mobileNumber,
  //         custName,
  //         supplierCode,
  //       );
  //     });
  //     setState(() {});
  //     _futureAlbum = fetchAlbum();
  //     getPref();
  //     return true;
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to update album.');
  //   }
  // }

  // // ignore: prefer_typing_uninitialized_variables
  // var mobileNumber;
  // // ignore: prefer_typing_uninitialized_variables
  // var customerName;
  // getPref() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     customerName = preferences.getString("custName");
  //     mobileNumber = preferences.getString("mobileNumber");
  //   });
  // }
}

// ignore: non_constant_identifier_names
ProfileScreenModel ProfileScreenModelFromJson(String str) =>
    ProfileScreenModel.fromJson(json.decode(str));

// ignore: non_constant_identifier_names
String ProfileScreenModelToJson(ProfileScreenModel data) =>
    json.encode(data.toJson());

class ProfileScreenModel {
  ProfileScreenModel({
    required this.isProfileCreated,
    required this.status,
    required this.message,
  });

  int isProfileCreated;
  int status;
  String message;

  factory ProfileScreenModel.fromJson(Map<String, dynamic> json) =>
      ProfileScreenModel(
        isProfileCreated: json["is_profile_created"],
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "is_profile_created": isProfileCreated,
        "status": status,
        "message": message,
      };
}

GetProfileModel getProfileModelFromJson(String str) =>
    GetProfileModel.fromJson(json.decode(str));

String getProfileModelToJson(GetProfileModel data) =>
    json.encode(data.toJson());

class GetProfileModel {
  GetProfileModel({
    required this.id,
    required this.groupId,
    required this.supplierCode,
    required this.name,
    required this.mobileNumber,
    required this.email,
    required this.group,
  });

  String id;
  String groupId;
  String supplierCode;
  String name;
  String mobileNumber;
  String email;
  List<Group> group;

  factory GetProfileModel.fromJson(Map<String, dynamic> json) =>
      GetProfileModel(
        id: json["id"],
        groupId: json["group_id"],
        supplierCode: json["supplier_code"],
        name: json["name"],
        mobileNumber: json["mobile_number"],
        email: json["email"],
        group: List<Group>.from(json["group"].map((x) => Group.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "group_id": groupId,
        "supplier_code": supplierCode,
        "name": name,
        "mobile_number": mobileNumber,
        "email": email,
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
