import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

final user = FirebaseAuth.instance.currentUser!;
String email = user.email!;

class _EditProfilePageState extends State<EditProfilePage> {
  File? _image;
  String? _uploadedImageUrl;
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
      var docID = await _firestore
          .collection("users")
          .where("UID", isEqualTo: user.uid)
          .get();
      final snapshot =
          await _firestore.collection('users').doc(docID.docs[0].id).get();

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

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });

      // Generate a unique file name or path
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Upload the image to Firebase Storage
      final storageReference = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('Profile_Images/$fileName.jpg');

      await storageReference.putFile(_image!);

      // Get the download URL of the uploaded image
      var imageUrl = await storageReference.getDownloadURL();
      storageReference.getData();
      setState(() {
        _uploadedImageUrl = imageUrl;
        updateUrl();
      });
    }
  }

  Future<void> updateOccupation() async {
    if (occupationController.text.trim().length > 2) {
      try {
        var docID = await _firestore
            .collection("users")
            .where("UID", isEqualTo: user.uid)
            .get();

        await _firestore.collection("users").doc(docID.docs[0].id).update({
          'occupation': occupationController.text.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('occupation updated successfully')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update occupation')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Failed to update occupation need to be more than 2 characters')),
      );
    }
  }

  Future<void> updateUrl() async {
    try {
      var docID = await _firestore
          .collection("users")
          .where("UID", isEqualTo: user.uid)
          .get();

      await _firestore.collection("users").doc(docID.docs[0].id).update({
        'user_profile_url': _uploadedImageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile picture updated successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile picture')),
      );
    }
  }

  Future<void> updateUsername() async {
    String input = usernameController.text.trim();
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: input)
        .limit(1)
        .get();
    // ignore: non_constant_identifier_names
    final SpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<> ]');

    if (input.length > 2 &&
        snapshot.docs.isEmpty &&
        !SpecialChar.hasMatch(input)) {
      try {
        var docID = await _firestore
            .collection("users")
            .where("UID", isEqualTo: user.uid)
            .get();

        await _firestore.collection("users").doc(docID.docs[0].id).update({
          'username': input,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('username updated successfully')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to username profile')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Failed to update username:\n This username already is used or you included special characters')),
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
        title: const Text(
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
            if (_image != null)
              Image.file(
                _image!,
                height: 200,
              ),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload Profile Picture'),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 50),
                backgroundColor: Colors.brown,
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: updateUsername,
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(80, 40),
                    backgroundColor: Colors.brown,
                  ),
                  child: Text('Update'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: occupationController,
                    decoration: InputDecoration(labelText: 'Occupation'),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: updateOccupation,
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(80, 40),
                    backgroundColor: Colors.brown,
                  ),
                  child: Text('Update'),
                ),
              ],
            ),
            SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}
