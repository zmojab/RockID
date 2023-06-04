<<<<<<< HEAD
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
=======
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
>>>>>>> db79a9fcd79e6558b22ca49ab2a5323305e38d69

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        title: Text('RockID'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Home Page',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
=======
        actions: [
          IconButton(
            onPressed: signUserOut, 
            icon: Icon(Icons.logout)
            )
          ],
      ),
      body: Center(
        child: Text(
          "Logged in as " + user.email!,
          style: TextStyle(fontSize: 20))),
    );
  }
}
>>>>>>> db79a9fcd79e6558b22ca49ab2a5323305e38d69
