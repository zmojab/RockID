import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rockid/pages/Home_page.dart';
import 'package:rockid/pages/profile_page.dart';
import 'package:rockid/pages/camera_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

final user = FirebaseAuth.instance.currentUser!;

String email = user.email!;

class _ProfilePageState extends State<ProfilePage> {
  //int _selectedIndex = 0;


  final List<Widget> _pages = [HomePage(), RockID(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 237, 223),
      appBar: AppBar(
        title: Text(
          'Profile Page',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        actions: [],
        backgroundColor: Colors.brown,
      ),
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
                    color: Colors.brown,
                  ),
                ),
                Card(
                  color: Colors.brown,
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.phone,
                      color: Colors.brown[200],
                    ),
                    title: Text(
                      '313-555-6789',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                ),
                Card(
                  color: Colors.brown,
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.email,
                      color: Colors.brown[200],
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera, color: Colors.grey),
            label: 'Rock Identifier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.brown),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          // Update the state and rebuild the widget
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => _pages[index]),
          );
        },
      ),
    );
  }
}
