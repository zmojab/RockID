import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rockid/components/disclaimer_popup.dart';
import 'package:rockid/pages/about_app_page.dart';
import '../pages/auth_page.dart';
import '../pages/settings_page.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({Key? key}) : super(key: key);

  Future<void> showAlertDialog(BuildContext context) async {
    Widget cancelButton = TextButton(
      child: Text(
        "Yes",
        style: TextStyle(color: Colors.brown),
      ),
      onPressed: () {
        signUserOut(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "No",
        style: TextStyle(color: Colors.brown),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: Color.fromARGB(255, 255, 237, 223),
      title: Text("Logging Out"),
      content: Text(
        "Would you like to log out?",
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> signUserOut(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    final user = FirebaseAuth.instance.currentUser!;
    String email = user.email.toString();
    print("email 2: " + email);
    try {
      final _providerData = _auth.currentUser!.providerData;
      if (_providerData.isNotEmpty) {
        // If user signed in through Google
        if (_providerData[0].providerId.toLowerCase().contains('google')) {
          GoogleSignIn googleSignIn = GoogleSignIn();
          await googleSignIn.signOut();
        }
      }
      await _auth.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AuthPage()),
        (route) => false,
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromARGB(255, 255, 237, 223),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.brown,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About App'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutAppPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.device_unknown),
            title: const Text('Disclaimer'),
            onTap: () {
              DisclaimerPopup.show(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              showAlertDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
