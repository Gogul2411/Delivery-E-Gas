import 'dart:convert';
import 'package:egas_delivery/common/colors.dart';
import 'package:egas_delivery/common/responsive.dart';
import 'package:egas_delivery/model_files/login_model.dart';
import 'package:egas_delivery/screens/bottom_navigation.dart';
import 'package:egas_delivery/widgets/custom_appbar.dart';
import 'package:egas_delivery/widgets/custom_button.dart';
import 'package:egas_delivery/widgets/custom_form.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
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
  FocusNode myFocusNode = FocusNode();
  final FocusNode _myFocusNode = FocusNode();

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
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar(
          appbarText: 'Sign In',
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          reverse: true,
          child: Container(
            color: kBackground,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        Image.asset(
                          "assets/icons/user.png",
                          width: 280,
                          height: 130,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Welcome Back!",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        const Text(
                          "Sign in to your account!",
                          style: TextStyle(color: kPrimaryLightColor),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        CustomForm(
                          myFocusNode: myFocusNode,
                          obscureTxt: false,
                          keyboardType: TextInputType.phone,
                          txtController: mobileController,
                          hintTxt: "Mobile Number*",
                          labelTxt: "Mobile Number*",
                          checkValidator: (value) {
                            if (value?.length != 10) {
                              return 'Please enter a valid mobile number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomForm(
                          maxlines: 1,
                          myFocusNode: _myFocusNode,
                          txtController: passwordController,
                          obscureTxt: !passwordVisibility,
                          keyboardType: TextInputType.visiblePassword,
                          hintTxt: "Password*",
                          labelTxt: "Password*",
                          icon: InkWell(
                            onTap: () => setState(
                              () => passwordVisibility = !passwordVisibility,
                            ),
                            focusNode: FocusNode(skipTraversal: true),
                            child: Icon(
                              passwordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: kPrimaryLightColor,
                              size: 22,
                            ),
                          ),
                          checkValidator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter valid password';
                            }
                            return null;
                          },
                        ),
                        // Align(
                        //   alignment: Alignment.topRight,
                        //   child: SizedBox(
                        //     width: 140,
                        //     child: TextButton(
                        //       onPressed: () {},
                        //       style: TextButton.styleFrom(
                        //         foregroundColor: kPrimaryLightColor,
                        //       ),
                        //       child: const Text(
                        //         'Forgot Password?',
                        //         textAlign: TextAlign.end,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 30),
                        SizedBox(
                          height: 55,
                          width: double.infinity,
                          child: CustomButton(
                            buttonText: 'Sign In',
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final String mobileNumber =
                                    mobileController.text.trim();
                                final String password =
                                    passwordController.text.trim();
                                final LoginModel? user =
                                    await loginUser(mobileNumber, password);
                                setState(
                                  () {
                                    _user = user;
                                  },
                                );
                                if (_user == null) {
                                  Fluttertoast.showToast(
                                      msg: "Invalid Credentials",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white);
                                } else {
                                  savePref(
                                      _user!.supplierCode,
                                      _user!.name,
                                      _user!.mobileNumber,
                                      _user!.groupId,
                                      _user!.dbId,
                                      _user!.email);
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
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<LoginModel?> loginUser(String mobileNumber, String password) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var fcmKey = preferences.getString("appToken");
  const String apiUrl = "${apiLink}loginDB";
  final response = await http.post(
    Uri.parse(apiUrl),
    body: {"mobileNumber": mobileNumber, "password": password, "fbid": fcmKey},
  );
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

savePref(String supplierCode, String name, String mobileNumber, String groupId,
    String dbId, String email) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString("supplierCode", supplierCode);
  preferences.setString("name", name);
  preferences.setString("mobileNumber", mobileNumber);
  preferences.setString("groupId", groupId);
  preferences.setString("dbId", dbId);
  preferences.setString("email", email);
  // ignore: deprecated_member_use
  preferences.commit();
}