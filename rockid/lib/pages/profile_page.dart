import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rockid/pages/Home_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

final user = FirebaseAuth.instance.currentUser!;

String email = user.email!;

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [HomePage(), ProfilePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Profile Page'), centerTitle: true, actions: []),
      body: SafeArea(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 80,
                  backgroundImage:
                      AssetImage('lib/images/Blank_profile (1).png'),
                ),
                Text(
                  'Users full name',
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  height: 20.0,
                  width: 200,
                  child: Divider(
                    color: Colors.lightBlue,
                  ),
                ),
                Card(
                  color: Colors.lightBlue,
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.phone,
                      color: Colors.lightBlue[200],
                    ),
                    title: Text(
                      '313-555-6789',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                ),
                Card(
                  color: Colors.lightBlue,
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.email,
                      color: Colors.lightBlue[200],
                    ),
                    title: Text(
                      email,
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
