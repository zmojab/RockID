import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rockid/pages/profile_page.dart';
import 'package:rockid/pages/camera_page.dart';
import 'package:rockid/pages/maps.dart';
import '../components/square_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

final user = FirebaseAuth.instance.currentUser!;

// Firebase sign out method is asynchronous, so making signUserOut asynchronous
Future<void> signUserOut() async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    final _providerData = _auth.currentUser!.providerData;
    if (_providerData.isNotEmpty) {
      // If user signed in through Google
      if (_providerData[0].providerId.toLowerCase().contains('google')) {
        GoogleSignIn googleSignIn = GoogleSignIn();
        googleSignIn.signOut();
      }
    }
    await _auth.signOut();
  } catch (e) {
    print(e);
  }
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    RockID(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 237, 223),
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          ),
        ],
        backgroundColor: Colors.brown,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapsPage()),
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.brown),
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.all(16.0), // Adjust the padding as needed
              ),
            ),
            child: Text(
              'Maps',
              style: TextStyle(
                fontSize: 20.0, // Adjust the font size as needed
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.brown),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera, color: Colors.grey),
            label: 'Rock Identifier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.grey),
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
