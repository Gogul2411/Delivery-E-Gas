import 'dart:convert';
import 'package:egas_delivery/common/colors.dart';
import 'package:egas_delivery/model_files/profile_model.dart';
import 'package:egas_delivery/widgets/custom_appbar.dart';
import 'package:egas_delivery/widgets/custom_button.dart';
import 'package:egas_delivery/widgets/custom_form.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'login_screen.dart';

Future<GetProfileModel> fetchAlbum() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var deliveryboy = preferences.getString("dbId");
  const String apiUrl = "${apiLink}getProfileDB";
  final response =
      await http.post(Uri.parse(apiUrl), body: {"db_id": deliveryboy});
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
        resizeToAvoidBottomInset: false,
        body: Container(
          color: kBackground,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            reverse: true,
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
                                      height: 20,
                                    ),
                                    SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: ProfilePicture(
                                        name: snapshot.data!.name.toString(),
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
                                        maxlines: 1,
                                        formEnabled: false,
                                        myFocusNode: supplierFocusNode,
                                        txtController: supplierController
                                          ..text = snapshot.data!.supplierName,
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
                                        txtController: nameController
                                          ..text = snapshot.data!.name,
                                        maxlines: 1,
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
                                        maxlines: 1,
                                        txtController: mobileController
                                          ..text = snapshot.data!.mobileNumber,
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
                                        txtController: emailController
                                          ..text = snapshot.data!.email,
                                        maxlines: 1,
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
                                      maxlines: 1,
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
                                          if (_formKey.currentState!
                                              .validate()) {
                                            final String mobileNumber =
                                                mobileController.text.trim();
                                            final String dbName =
                                                nameController.text.trim();
                                            final String email =
                                                emailController.text.trim();
                                            final String password =
                                                passwordController.text.trim();
                                            // ignore: unused_local_variable
                                            final user = updateProfile(
                                                mobileNumber,
                                                dbName,
                                                email,
                                                password);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    const Text(
                                      "Version 1.0.0",
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

  Future<bool> updateProfile(
      String mobileNumber, String dbName, String email, String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var deliveryboy = preferences.getString("dbId");
    const String apiUrl = "${apiLink}saveProfile";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        {
          "db_id": deliveryboy,
          "name": dbName,
          "mobile_number": mobileNumber,
          "email": email,
          "password": password
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
      _futureAlbum = fetchAlbum();
      setState(() {});
      return true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update album.');
    }
  }
}
