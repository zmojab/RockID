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
bool isFullNamePrivate = false;
bool isEmailPrivate = false;
bool isPhoneNumberPrivate = false;
String _message = "";

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

// Inside your function or class
User user = FirebaseAuth.instance.currentUser!;

class _EditProfilePageState extends State<EditProfilePage> {
  void _refreshUser() async {
    User? user1 = FirebaseAuth.instance.currentUser;

    if (user1 != null) {
      try {
        user.reload();
        setState(() {
          user = FirebaseAuth.instance.currentUser!;
        });
        print('User refreshed successfully!');
      } catch (e) {
        print('Error refreshing user: $e');
      }
    } else {
      print('User not currently signed in.');
    }
  }

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
    _refreshUser();
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
          print("loaded attributes");
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
          const SnackBar(content: Text('Updated profile picture')),
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
    var collection = FirebaseFirestore.instance.collection("users");
    var username = await collection.where("UID", isEqualTo: user.uid).get();

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
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to username profile')),
        );
      }
    } else if (input == username.docs[0].data()['username']) {
      print("Same username");
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

    if (location.length > 2 &&
        alphanumericWithSpaces.hasMatch(location) &&
        locationController.text.trim().length < 30) {
      try {
        var docID = await UserCRUD().getUserDocID(user.uid);
        if (docID != null) {
          await UserCRUD().updateUserLocation(docID, location);
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

  Future<void> updateFullNameStatus() async {
    try {
      var docID = await UserCRUD().getUserDocID(user.uid);
      if (docID != null) {
        await UserCRUD().updateUserFullNameStatus(docID, isFullNamePrivate);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to update full name privacy status')),
      );
    }
  }

  Future<void> updateEmailStatus() async {
    try {
      var docID = await UserCRUD().getUserDocID(user.uid);
      if (docID != null) {
        await UserCRUD().updateUserEmailStatus(docID, isEmailPrivate);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update email privacy status')),
      );
    }
  }

  Future<void> updatePhoneNumberStatus() async {
    try {
      var docID = await UserCRUD().getUserDocID(user.uid);
      if (docID != null) {
        await UserCRUD()
            .updateUserPhoneNumberStatus(docID, isPhoneNumberPrivate);
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
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: Text('Edit Profile', style: TextStyle(fontSize: 30)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate to the SpecificPage when the AppBar's leading icon (back arrow) is tapped
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
              if (_image != null)
                Column(
                  children: [
                    Image.file(
                      _image!,
                      height: 200,
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ElevatedButton(
                onPressed: _uploadImage,
                child: Text('Change Profile Picture'),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 50),
                  backgroundColor: ForegroundColor,
                ),
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
                  SizedBox(
                    height: 50,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Switch.adaptive(
                                value: isFullNamePrivate,
                                onChanged: (value) {
                                  setState(() {
                                    isFullNamePrivate = value;
                                  });
                                },
                                activeColor: switchColor,
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
                  ],
                ),
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
                ],
              ),
              SizedBox(height: 16.0),
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
                  SizedBox(
                    height: 50,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Switch.adaptive(
                                value: isPhoneNumberPrivate,
                                onChanged: (value) {
                                  setState(() {
                                    isPhoneNumberPrivate = value;
                                  });
                                },
                                activeColor: switchColor,
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      user.email!.toString(),
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  SizedBox(
                    height: 50,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Switch.adaptive(
                                value: isEmailPrivate,
                                onChanged: (value) {
                                  setState(() {
                                    isEmailPrivate = value;
                                  });
                                },
                                activeColor: switchColor,
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
              SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      updateUsername();
                      updateFullName();
                      updatePhoneNumber();
                      updateOccupation();
                      updateLocation();
                      updateBio();
                      updateFullNameStatus();
                      updateEmailStatus();
                      updatePhoneNumberStatus();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fields are updated')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(150, 50),
                      backgroundColor: ForegroundColor,
                    ),
                    child: Text('Update'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
