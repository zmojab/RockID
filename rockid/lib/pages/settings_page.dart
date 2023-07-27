import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:rockid/classifier/styles.dart';
import 'package:rockid/pages/home_page.dart';
import 'package:rockid/pages/profile_page.dart';
import 'dart:io';
import '../components/hamburger_menu.dart';
import '../data/users.dart';

bool isProfilePrivate = false;

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

final user = FirebaseAuth.instance.currentUser!;

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    fetchProfileStatus();
  }

  Future<void> fetchProfileStatus() async {
    try {
      var docID = await UserCRUD().getUserDocID(user.uid);
      if (docID != null) {
        final snapshot = await UserCRUD().getUserProfile(docID);
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          setState(() {
            isProfilePrivate = data['profilePrivate'] as bool? ?? true;
          });
        }
      }
    } catch (error) {
      print('Error fetching user profile status: $error');
    }
  }

  Future<void> updateProfileStatus() async {
    try {
      var docID = await UserCRUD().getUserDocID(user.uid);
      if (docID != null) {
        await UserCRUD().updateUserProfileStatus(docID, isProfilePrivate);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to update profile privacy status')),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: Text('Settings', style: TextStyle(fontSize: 30)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ),
        backgroundColor: backgroundColor,
        endDrawer: HamburgerMenu(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 16.0),
                  Row(children: [
                    Text('Profile', style: TextStyle(fontSize: 20)),
                    Spacer(),
                    Switch(
                      value: isProfilePrivate,
                      activeColor: switchColor,
                      onChanged: (value) {
                        setState(() {
                          isProfilePrivate = value;
                        });
                        updateProfileStatus();
                      },
                    ),
                    Text('Private'),
                  ])
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
