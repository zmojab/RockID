import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rockid/pages/Home_page.dart';
import 'package:rockid/pages/camera_page.dart';
import 'package:rockid/pages/edit_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:rockid/pages/profile_page.dart';

import 'other_users_collection.dart';

class OtherUserProfilePage extends StatefulWidget {
  final String uid;
  const OtherUserProfilePage({required this.uid});

  @override
  _OtherUserProfilePageState createState() => _OtherUserProfilePageState();
}

// default image
String _url = "";
String _username = "";
String _occ = "";
String _bio = "";
String _fullname = "";
String _fullnamePrivate = "";
String _phoneNumber = "";
String _phoneNumberPrivate = "";
String _emailPrivate = "";
String _location = "";

int _rocks = 0;
final user = FirebaseAuth.instance.currentUser!;
String email = user.email!;

var collection = FirebaseFirestore.instance.collection("users");

class _OtherUserProfilePageState extends State<OtherUserProfilePage> {
  final List<Widget> _pages = [HomePage(), RockID(), ProfilePage()];

  @override
  void initState() {
    super.initState();
    _set_user_info();
  }

  Future<void> _set_user_info() async {
    var username = await collection.where("UID", isEqualTo: user.uid).get();

    try {
      if (username.docs.isNotEmpty) {
        setState(() {
          _username = username.docs[0].data()['username'];
          _occ = username.docs[0].data()['occupation'];
          _url = username.docs[0].data()['user_profile_url'];
          _fullname = username.docs[0].data()['fullName'];
          _fullnamePrivate = username.docs[0].data()['fullNamePrivate'];
          _bio = username.docs[0].data()['bio'];
          _phoneNumber = username.docs[0].data()['phoneNumber'];
          _phoneNumberPrivate = username.docs[0].data()['phoneNumberPrivate'];
          _location = username.docs[0].data()['location'];
          _emailPrivate = username.docs[0].data()['emailPrivate'];
        });
      }
    } catch (e) {
      print("could not get user info information");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 237, 223),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile Page',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(_url),
                ),
                Text(
                  _fullname,
                  style: TextStyle(fontSize: 22),
                ),
                const SizedBox(
                  height: 20.0,
                  width: 200,
                  child: Divider(
                    color: Colors.brown,
                  ),
                ),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  child: Card(
                    color: Color.fromARGB(255, 255, 237, 223),
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 25.0,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.person,
                        color: Colors.brown,
                      ),
                      title: const Text(
                        'USERNAME:',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        _username,
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  child: Card(
                    color: Color.fromARGB(255, 255, 237, 223),
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 25.0,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.work,
                        color: Colors.brown,
                      ),
                      title: const Text(
                        'OCCUPATION:',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        _occ,
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                if (_emailPrivate == false)
                  DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    child: Card(
                      color: Color.fromARGB(255, 255, 237, 223),
                      margin: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 25.0,
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.email,
                          color: Colors.brown,
                        ),
                        title: const Text(
                          'EMAIL:',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          email,
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if(_phoneNumberPrivate == false)
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  child: Card(
                    color: Color.fromARGB(255, 255, 237, 223),
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 25.0,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.phone,
                        color: Colors.brown,
                      ),
                      title: const Text(
                        'PHONE NUMBER:',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        _phoneNumber,
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  child: Card(
                    color: Color.fromARGB(255, 255, 237, 223),
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 25.0,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.location_city,
                        color: Colors.brown,
                      ),
                      title: const Text(
                        'LOCATION:',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        _location,
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  child: Card(
                    color: Color.fromARGB(255, 255, 237, 223),
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 25.0,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.person_2_outlined,
                        color: Colors.brown,
                      ),
                      title: const Text(
                        'BIO:',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        _bio,
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtherUsersRocksPage(uid: uid),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, 50),
                    backgroundColor:
                        Colors.brown, // Set the button background color
                  ),
                  child: const Text('Rock Collection',
                      style: TextStyle(fontSize: 15)),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gps_fixed_sharp, color: Colors.grey),
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
