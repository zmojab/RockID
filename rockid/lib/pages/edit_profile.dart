import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController usernameController;
  late TextEditingController occupationController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    occupationController = TextEditingController();

    // Fetch user profile data and populate the text fields
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      final snapshot = await _firestore.collection('users').doc(user.uid).get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;

        setState(() {
          usernameController.text = data['username'] as String? ?? '';
          occupationController.text = data['occupation'] as String? ?? '';
        });
      }
    } catch (error) {
      print('Error fetching user profile: $error');
    }
  }

  Future<void> updateProfile() async {
    try {
      await _firestore.collection('users').doc(user.uid).update({
        'username': usernameController.text.trim(),
        'occupation': occupationController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    occupationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        actions: [],
        backgroundColor: Colors.brown,
      ),
      backgroundColor: Color.fromARGB(255, 255, 237, 223),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: occupationController,
              decoration: InputDecoration(labelText: 'Occupation'),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: updateProfile,
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 60),
                backgroundColor:
                    Colors.brown, // Set the button background color
              ),
              child: const Text('SAVE', style: TextStyle(fontSize: 20)),
            )
          ],
        ),
      ),
    );
  }
}
