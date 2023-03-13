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
import '../widgets/logout.dart';

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
    passwordController = TextEditingController();
    _futureAlbum = fetchAlbum();
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
          action: const [
            logout(),
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          color: kBackground,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
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
                            String? mobileNumber = snapshot.data!.mobileNumber;
                            String? dbName = snapshot.data!.name;
                            String? email = snapshot.data!.email;

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
                                        initial: snapshot.data!.supplierName,
                                        onChanged: (value) {},
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
                                        initial: snapshot.data!.name,
                                        onChanged: (value) {
                                          dbName = value;
                                        },
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
                                        initial: snapshot.data!.mobileNumber,
                                        onChanged: (value) {
                                          mobileNumber = value;
                                        },
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
                                        initial: snapshot.data!.email,
                                        onChanged: (value) {
                                          email = value;
                                        },
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
                                      controller: passwordController,
                                      labelTxt: 'Password',
                                      hintTxt: 'Password',
                                      maxlines: 1,
                                      checkValidator: null,
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
                                            final String mobile =
                                                mobileNumber.toString();
                                            final String deliveryboy =
                                                dbName.toString();
                                            final String gmail =
                                                email.toString();
                                            final String pass =
                                                passwordController.text.trim();
                                            // ignore: unused_local_variable
                                            final user = updateProfile(mobile,
                                                deliveryboy, gmail, pass);
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
      String mobile, String deliveryboy, String gmail, String pass) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var deliveryboyId = preferences.getString("dbId");
    const String apiUrl = "${apiLink}saveProfile";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        {
          "db_id": deliveryboyId,
          "name": deliveryboy,
          "mobile_number": mobile,
          "email": gmail,
          "password": pass
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
      setState(() {
        passwordController = TextEditingController();
        _futureAlbum = fetchAlbum();
      });
      return true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update album.');
    }
  }
}
