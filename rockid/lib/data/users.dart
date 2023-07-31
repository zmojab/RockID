import 'package:cloud_firestore/cloud_firestore.dart';

//users CRUD class for operations on user collection JW
//methods extracted from edit_profile and originally introduced by AW

class UserCRUD {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String?> getUserDocID(String uid) async {
    try {
      var docID = await _firestore
          .collection("users")
          .where("UID", isEqualTo: uid)
          .get();
      if (docID.docs.isNotEmpty) {
        return docID.docs[0].id;
      }
    } catch (error) {
      print('Error getting user doc ID: $error');
    }
    return null;
  }

  Future<DocumentSnapshot> getUserProfile(String? docID) async {
    if (docID != null) {
      return _firestore.collection('users').doc(docID).get();
    }
    throw Exception('User doc ID is null');
  }

  Future<QuerySnapshot> getUserByUsername(String username) async {
    return _firestore
        .collection("users")
        .where("username", isEqualTo: username)
        .limit(1)
        .get();
  }

  Future<void> updateUserOccupation(String? docID, String occupation) async {
    if (docID != null) {
      await _firestore.collection("users").doc(docID).update({
        'occupation': occupation,
      });
    } else {
      throw Exception('User doc ID is null');
    }
  }

 Future<void> updateUserProfileUrl(String? docID, String? profileUrl) async {
    if (docID != null) {
      await _firestore.collection("users").doc(docID).update({
        'user_profile_url': profileUrl,
      });
    } else {
      throw Exception('User doc ID is null');
    }
  }
  
  Future<void> updateUserUsername(String? docID, String username) async {
    if (docID != null) {
      await _firestore.collection("users").doc(docID).update({
        'username': username,
      });
    } else {
      throw Exception('User doc ID is null');
    }
  }

//updates user's location JW
  Future<void> updateUserLocation(String? docID, String location) async {
    if (docID != null) {
      await _firestore.collection("users").doc(docID).update({
        'location': location,
      });
    } else {
      throw Exception('User doc ID is null');
    }
  }

//updates user's bio JW
  Future<void> updateUserBio(String? docID, String bio) async {
    if (docID != null) {
      await _firestore.collection("users").doc(docID).update({
        'bio': bio,
      });
    } else {
      throw Exception('User doc ID is null');
    }
  }

//updates user's profile privacy status JW
Future<void> updateUserProfileStatus(String? docID, bool isProfilePrivate) async {
    if (docID != null) {
      await _firestore.collection("users").doc(docID).update({
        'profilePrivate': isProfilePrivate,
      });
    } else {
      throw Exception('User doc ID is null');
    }
  }

  Future<void> updateUserFullNameStatus(String? docID, bool isFullNamePrivate) async {
    if (docID != null) {
      await _firestore.collection("users").doc(docID).update({
        'fullNamePrivate': isFullNamePrivate,
      });
    } else {
      throw Exception('User doc ID is null');
    }
  }

//updates user's email privacy status JW
  Future<void> updateUserEmailStatus(String? docID, bool isEmailPrivate) async {
    if (docID != null) {
      await _firestore.collection("users").doc(docID).update({
        'emailPrivate': isEmailPrivate,
      });
    } else {
      throw Exception('User doc ID is null');
    }
  }

  //updates user's phone number privacy status JW
  Future<void> updateUserPhoneNumberStatus(String? docID, bool isPhoneNumberPrivate) async {
    if (docID != null) {
      await _firestore.collection("users").doc(docID).update({
        'phoneNumberPrivate': isPhoneNumberPrivate,
      });
    } else {
      throw Exception('User doc ID is null');
    }
  }

//gets username for display purposes JW
  Future<String?> getUsernameFromUid(String uid) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection("users")
          .where("UID", isEqualTo: uid)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs[0].data() as Map<String, dynamic>;
        return data?['username'] as String?;
      }
    } catch (error) {
      print('Error getting username from UID: $error');
    }
    return null;
  }

  //updates user's full name JW
  Future<void> updateUserFullName(String? docID, String fullName) async {
    if (docID != null) {
      await _firestore.collection("users").doc(docID).update({
        'fullName': fullName,
      });
    } else {
      throw Exception('User doc ID is null');
    }
  }

  //updates user's phone number JW
  Future<void> updateUserPhoneNumber(String? docID, String phoneNumber) async {
    if (docID != null) {
      await _firestore.collection("users").doc(docID).update({
        'phoneNumber': phoneNumber,
      });
    } else {
      throw Exception('User doc ID is null');
    }
  }

}