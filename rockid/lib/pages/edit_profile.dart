import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'dart:io';
import '../data/users.dart';

bool isProfilePrivate = false;
bool isFullNamePrivate = false;
bool isEmailPrivate = false;
bool isPhoneNumberPrivate = false;

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

  late TextEditingController usernameController;
  late TextEditingController fullNameController;
  late TextEditingController phoneNumberController;
  late TextEditingController occupationController;
  late TextEditingController locationController;
  late TextEditingController bioController;

  var phoneNumberFormatter = MaskTextInputFormatter(
    mask: '(###) ###-####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    fullNameController = TextEditingController();
    phoneNumberController = TextEditingController();
    occupationController = TextEditingController();
    locationController = TextEditingController();
    bioController = TextEditingController();

    // Fetch user profile data and populate the text fields
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      var docID = await UserCRUD().getUserDocID(user.uid);
      if (docID != null) {
        final snapshot = await UserCRUD().getUserProfile(docID);
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;

          setState(() {
            usernameController.text = data['username'] as String? ?? '';
            fullNameController.text = data['fullName'] as String? ?? '';
            phoneNumberController.text =
                formatPhoneNumber(data['phoneNumber'] as String? ?? '');
            occupationController.text = data['occupation'] as String? ?? '';
            locationController.text = data['location'] as String? ?? '';
            bioController.text = data['bio'] as String? ?? '';
            isProfilePrivate = data['profilePrivate'] as bool? ?? true;
            isFullNamePrivate = data['fullNamePrivate'] as bool? ?? true;
            isEmailPrivate = data['emailPrivate'] as bool? ?? true;
            isPhoneNumberPrivate = data['phoneNumberPrivate'] as bool? ?? true;
          });
        }
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
    if (occupationController.text.trim().length > 2 &&
        occupationController.text.trim().length < 30) {
      try {
        var docID = await UserCRUD().getUserDocID(user.uid);
        if (docID != null) {
          await UserCRUD()
              .updateUserOccupation(docID, occupationController.text.trim());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Occupation updated successfully')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update occupation')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Failed to update occupation. Must be between 2 and 30 characters.'),
        ),
      );
    }
  }

  Future<void> updateFullName() async {
    if (fullNameController.text.trim().length < 100) {
      try {
        var docID = await UserCRUD().getUserDocID(user.uid);
        if (docID != null) {
          await UserCRUD()
              .updateUserFullName(docID, fullNameController.text.trim());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Full name updated successfully')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update full name')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Failed to update full name. Full name must be 100 characters or less.'),
        ),
      );
    }
  }

  Future<void> updatePhoneNumber() async {
    String phoneNumber = phoneNumberController.text.trim();
    print(phoneNumber.length);

    if (phoneNumber.length == 14) {
      phoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
      try {
        var docID = await UserCRUD().getUserDocID(user.uid);
        if (docID != null) {
          await UserCRUD().updateUserPhoneNumber(docID, phoneNumber);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Phone number updated successfully')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update phone number')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Failed to update phone number. Please enter a valid 10-digit phone number.'),
        ),
      );
    }
  }

  Future<void> updateUrl() async {
    try {
      var docID = await UserCRUD().getUserDocID(user.uid);
      if (docID != null) {
        await UserCRUD().updateUserProfileUrl(docID, _uploadedImageUrl);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile picture')),
      );
    }
  }

  Future<void> updateUsername() async {
    String input = usernameController.text.trim();
    final QuerySnapshot snapshot = await UserCRUD().getUserByUsername(input);
    // ignore: non_constant_identifier_names
    final SpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<> ]');

    if (input.length > 2 &&
        snapshot.docs.isEmpty &&
        !SpecialChar.hasMatch(input) &&
        input.length < 30) {
      try {
        var docID = await UserCRUD().getUserDocID(user.uid);
        if (docID != null) {
          await UserCRUD().updateUserUsername(docID, input);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Username updated successfully')),
          );
        }
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

  Future<void> updateLocation() async {
    String location = locationController.text.trim();
    final RegExp alphanumericWithSpaces = RegExp(r'^[a-zA-Z0-9\s]+$');

    if (location.length > 2 && alphanumericWithSpaces.hasMatch(location)) {
      try {
        var docID = await UserCRUD().getUserDocID(user.uid);
        if (docID != null) {
          await UserCRUD().updateUserLocation(docID, location);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location updated successfully')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update location')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Failed to update location. Location must be at least 2 characters long and alphanumeric with spaces.'),
        ),
      );
    }
  }

  Future<void> updateBio() async {
    String bio = bioController.text.trim();

    if (bio.length <= 250) {
      try {
        var docID = await UserCRUD().getUserDocID(user.uid);
        if (docID != null) {
          await UserCRUD().updateUserBio(docID, bio);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bio updated successfully')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update location')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Failed to update bio. Bio must be 250 characters or less.'),
        ),
      );
    }
  }

  Future<void> updateProfileStatus(bool isProfilePrivate) async {
    try {
      var docID = await UserCRUD().getUserDocID(user.uid);
      if (docID != null) {
        await UserCRUD().updateUserProfileStatus(docID, isProfilePrivate);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Profile privacy status updated successfully')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to update profile privacy status')),
      );
    }
  }

  Future<void> updateFullNameStatus(bool isFullNamePrivate) async {
    try {
      var docID = await UserCRUD().getUserDocID(user.uid);
      if (docID != null) {
        await UserCRUD().updateUserFullNameStatus(docID, isFullNamePrivate);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Full name privacy status updated successfully')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to update full name privacy status')),
      );
    }
  }

  Future<void> updateEmailStatus(bool isEmailPrivate) async {
    try {
      var docID = await UserCRUD().getUserDocID(user.uid);
      if (docID != null) {
        await UserCRUD().updateUserEmailStatus(docID, isEmailPrivate);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Email privacy status updated successfully')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update email privacy status')),
      );
    }
  }

  Future<void> updatePhoneNumberStatus(bool isPhoneNumberPrivate) async {
    try {
      var docID = await UserCRUD().getUserDocID(user.uid);
      if (docID != null) {
        await UserCRUD()
            .updateUserPhoneNumberStatus(docID, isPhoneNumberPrivate);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Phone number privacy status updated successfully')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to update phone number privacy status')),
      );
    }
  }

  String formatPhoneNumber(String phoneNumber) {
    final maskedText = phoneNumberFormatter.maskText(phoneNumber);
    return maskedText;
  }

  @override
  void dispose() {
    usernameController.dispose();
    bioController.dispose();
    fullNameController.dispose();
    phoneNumberController.dispose();
    occupationController.dispose();
    locationController.dispose();
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    fixedSize: const Size(90, 40),
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
                    controller: fullNameController,
                    decoration: InputDecoration(labelText: 'Full Name'),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: updateFullName,
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(90, 40),
                    backgroundColor: Colors.brown,
                  ),
                  child: Text('Update'),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: phoneNumberController,
                    inputFormatters: [phoneNumberFormatter],
                    decoration: InputDecoration(labelText: 'Phone Number'),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: updatePhoneNumber,
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(90, 40),
                    backgroundColor: Colors.brown,
                  ),
                  child: Text('Update'),
                ),
              ],
            ),
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
                    fixedSize: const Size(90, 40),
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
                    controller: locationController,
                    decoration: InputDecoration(labelText: 'Location'),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: updateLocation,
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(90, 40),
                    backgroundColor: Colors.brown,
                  ),
                  child: Text('Update'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Container(
              constraints: BoxConstraints(
                maxHeight: 200.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: bioController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(labelText: 'Bio'),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: updateBio,
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(90, 40),
                      backgroundColor: Colors.brown,
                    ),
                    child: Text('Update'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 50,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Privacy Options',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Profile',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Switch.adaptive(
                              value: isProfilePrivate,
                              onChanged: (value) {
                                setState(() {
                                  isProfilePrivate = value;
                                });
                                updateProfileStatus(value);
                              },
                              activeColor: Color.fromARGB(247, 242, 137, 38),
                            ),
                            Text('Private'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Full Name',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Switch.adaptive(
                              value: isFullNamePrivate,
                              onChanged: (value) {
                                setState(() {
                                  isFullNamePrivate = value;
                                });
                                updateFullNameStatus(value);
                              },
                              activeColor: Color.fromARGB(247, 242, 137, 38),
                            ),
                            Text('Private'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Email',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Switch.adaptive(
                              value: isEmailPrivate,
                              onChanged: (value) {
                                setState(() {
                                  isEmailPrivate = value;
                                });
                                updateEmailStatus(value);
                              },
                              activeColor: Color.fromARGB(247, 242, 137, 38),
                            ),
                            Text('Private'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Phone Number',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Switch.adaptive(
                              value: isPhoneNumberPrivate,
                              onChanged: (value) {
                                setState(() {
                                  isPhoneNumberPrivate = value;
                                });
                                updatePhoneNumberStatus(value);
                              },
                              activeColor: Color.fromARGB(247, 242, 137, 38),
                            ),
                            Text('Private'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
