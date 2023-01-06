import 'dart:convert';
import 'package:egas_delivery/common/colors.dart';
import 'package:egas_delivery/common/responsive.dart';
import 'package:egas_delivery/screens/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Responsive(
        mobile: const MobileLoginScreen(),
        desktop: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    width: 450,
                    child: MobileLoginScreen(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late bool passwordVisibility;
  LoginModel? _user;

  @override
  void initState() {
    super.initState();
    mobileController = TextEditingController();
    passwordController = TextEditingController();
    passwordVisibility = false;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icons/user.png",
                width: 280,
                height: 130,
              ),
              const Text(
                'Login',
                style: TextStyle(fontSize: 20, color: kPrimaryColor),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: mobileController,
                onChanged: (value) {},
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone_in_talk_rounded),
                  hintText: 'Mobile Number *',
                  labelText: 'Mobile Number *',
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 18.0),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF101213),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 0, 0, 0),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value?.length != 10) {
                    return 'Please enter a valid mobile number';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 3,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: passwordController,
                  obscureText: !passwordVisibility,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    hintText: 'Password *',
                    labelText: 'Password *',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18.0, horizontal: 18.0),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 0, 0, 0),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFF101213),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: InkWell(
                      onTap: () => setState(
                        () => passwordVisibility = !passwordVisibility,
                      ),
                      focusNode: FocusNode(skipTraversal: true),
                      child: Icon(
                        passwordVisibility
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: const Color(0xFF95A1AC),
                        size: 22,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter valid password';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Hero(
                tag: "login_btn",
                child: SizedBox(
                  width: double.infinity,
                  height: 55.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final String mobileNumber =
                            mobileController.text.trim();
                        final String password = passwordController.text.trim();
                        final LoginModel? user =
                            await loginUser(mobileNumber, password);
                        setState(() {
                          _user = user;
                        });
                        if (_user == null) {
                          Fluttertoast.showToast(
                              msg: "Invalid Credentials",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          savePref(_user!.supplierCode, _user!.custName,
                              _user!.mobileNumber, _user!.custId);
                          // ignore: use_build_context_synchronously
                          Navigator.of(context, rootNavigator: true)
                              .pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return const HomePage();
                              },
                            ),
                            (_) => false,
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor, elevation: 0),
                    child: Text(
                      "Login".toUpperCase(),
                      style: const TextStyle(fontSize: 15, letterSpacing: 1),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: kPrimaryColor,
                ),
                child: const Text(
                  'Forgot Password ?',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<LoginModel?> loginUser(String mobileNumber, String password) async {
  const String apiUrl = "${apiLink}login";
  final response = await http.post(Uri.parse(apiUrl),
      body: {"mobile_number": mobileNumber, "password": password});
  String jsonsDataString = response.body
      .toString(); // toString of Response's body is assigned to jsonDataString
  // ignore: no_leading_underscores_for_local_identifiers
  var _data = jsonDecode(jsonsDataString);
// ignore: avoid_print
  print(_data.toString());
  if (response.statusCode == 201) {
    final String responseString = response.body;
    return loginModelFromJson(responseString);
  } else {
    return null;
  }
}

savePref(String supplierCode, String custName, String mobileNumber,
    String custId) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString("supplierCode", supplierCode);
  preferences.setString("custName", custName);
  preferences.setString("mobileNumber", mobileNumber);
  preferences.setString("custId", custId);
  // ignore: deprecated_member_use
  preferences.commit();
}

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    required this.fbid,
    required this.supplierCode,
    required this.custId,
    required this.mobileNumber,
    required this.custName,
    required this.custCode,
    required this.isProfileCreated,
  });

  dynamic fbid;
  String supplierCode;
  String custId;
  String mobileNumber;
  String custName;
  String custCode;
  String isProfileCreated;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        fbid: json["fbid"],
        supplierCode: json["supplier_code"],
        custId: json["cust_id"],
        mobileNumber: json["mobile_number"],
        custName: json["cust_name"],
        custCode: json["cust_code"],
        isProfileCreated: json["is_profile_created"],
      );

  Map<String, dynamic> toJson() => {
        "fbid": fbid,
        "supplier_code": supplierCode,
        "cust_id": custId,
        "mobile_number": mobileNumber,
        "cust_name": custName,
        "cust_code": custCode,
        "is_profile_created": isProfileCreated,
      };
}
