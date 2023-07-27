import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:rockid/classifier/styles.dart';
import 'package:rockid/components/hamburger_menu.dart';
import 'package:rockid/pages/Home_page.dart';
import 'package:rockid/pages/camera_page.dart';
import 'package:rockid/pages/edit_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

//default image
String _url = "";

String _username = "";
String _occ = "";
String _bio = "";
String _fullname = "";
String _phoneNumber = "";
String _location = "";

int _rocks = 0;
final user = FirebaseAuth.instance.currentUser!;
String email = user.email!;
String uid = user.uid;

var collection = FirebaseFirestore.instance.collection("users");
var phoneNumberFormatter = MaskTextInputFormatter(
  mask: '(###) ###-####',
  filter: {'#': RegExp(r'[0-9]')},
);
String formatPhoneNumber(String phoneNumber) {
  final maskedText = phoneNumberFormatter.maskText(phoneNumber);
  return maskedText;
}



class _ProfilePageState extends State<ProfilePage> {
  final List<Widget> _pages = [HomePage(), RockID(), ProfilePage()];

  @override
  void initState() {
    super.initState();
    _set_user_info();
  }

  Future<void> _set_user_info() async {
    var username = await collection.where("UID", isEqualTo: user.uid).get();
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot snapshot = await firestore
        .collection('rocks_found')
        .where('UID', isEqualTo: user.uid)
        .get();

    try {
      if (username.docs.isNotEmpty) {
        setState(() {
          _username = username.docs[0].data()['username'];
          _occ = username.docs[0].data()['occupation'];
          _rocks = snapshot.size;
          _url = username.docs[0].data()['user_profile_url'];
          _fullname = username.docs[0].data()['fullName'];
          _bio = username.docs[0].data()['bio'];
          _phoneNumber =
              formatPhoneNumber(username.docs[0].data()['phoneNumber']);
          _location = username.docs[0].data()['location'];
        });
      }
    } catch (e) {
      print("could not get user info information");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile Page',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
        backgroundColor: ForegroundColor,
      ),
      endDrawer: HamburgerMenu(),
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
                SizedBox(height: 20),
                Text(
                  _fullname,
                  style: GoogleFonts.ptSans(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    textStyle: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 0.0,
                  width: 200,
                  child: Divider(
                    color: ForegroundColor,
                  ),
                ),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  child: Card(
                    color: backgroundColor,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 25.0,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.person,
                        color: ForegroundColor,
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
                    color: backgroundColor,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 25.0,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.person_2_outlined,
                        color: ForegroundColor,
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
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  child: Card(
                    color: backgroundColor,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 25.0,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.work,
                        color: ForegroundColor,
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
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  child: Card(
                    color: backgroundColor,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 25.0,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.location_city,
                        color: ForegroundColor,
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
                    color: backgroundColor,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 25.0,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.email,
                        color: ForegroundColor,
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
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  child: Card(
                    color: backgroundColor,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 25.0,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.phone,
                        color: ForegroundColor,
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
                    color: backgroundColor,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 25.0,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.search,
                        color: ForegroundColor,
                      ),
                      title: const Text(
                        'ROCKS FOUND:',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        _rocks.toString(),
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
                          builder: (context) => EditProfilePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, 50),
                    backgroundColor:
                        ForegroundColor, // Set the button background color
                  ),
                  child: const Text('EDIT PROFILE',
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
            icon: Icon(Icons.person, color: ForegroundColor),
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
