import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/login_screen.dart';

// ignore: camel_case_types
class logout extends StatelessWidget {
  const logout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        showDialog<bool>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              'Logout !!',
              style: TextStyle(color: Colors.red),
            ),
            content: const Text('Are you sure want to Log out'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('NO'),
              ),
              TextButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove("mobileNumber");
                  prefs.remove("companyName");
                  prefs.remove("userId");
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
                child: const Text('YES'),
              ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.logout_sharp),
    );
  }
}
