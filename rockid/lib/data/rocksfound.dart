import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

// RocksFoundCrud class for CRUD operations on rocks_found collection JW

class RocksFoundCRUD {
  // Collection reference JW
  final CollectionReference rocksFoundCollection =
      FirebaseFirestore.instance.collection('rocks_found');

  // Adds rock found with location JW
  Future<void> addRockFoundWithLocation(
      String uid,
      String rockClassification,
      String rockImageUrl,
      double lattitude,
      double longitude,
      String city,
      DateTime dateTime) async {
    try {
      await rocksFoundCollection.doc().set({
        'UID': uid,
        'ROCK_CLASSIFICATION': rockClassification.toLowerCase(),
        'ROCK_IMAGE_URL': rockImageUrl,
        'LATTITUDE': lattitude,
        'LONGITUDE': longitude,
        'CITY': city,
        'CAN_BE_VIEWED': true,
        'VIEWABLE': true,
        'DATETIME': dateTime,
      });
    } catch (e) {
      print(e);
    }
  }

  // Adds rock found without location JW
  Future<void> addRockFoundWithOutLocation(String uid,
      String rockClassification, String rockImageUrl, DateTime dateTime) async {
    try {
      await rocksFoundCollection.doc().set({
        'UID': uid,
        'ROCK_CLASSIFICATION': rockClassification.toLowerCase(),
        'ROCK_IMAGE_URL': rockImageUrl,
        'CAN_BE_VIEWED': false,
        'VIEWABLE': false,
        'DATETIME': dateTime,
      });
    } catch (e) {
      print(e);
    }
  }

  //returns list of all rocs found JW
  Future<List<Map<String, dynamic>>> getRocksFound() async {
    List<Map<String, dynamic>> rocksFound = [];
    try {
      QuerySnapshot snapshot = await rocksFoundCollection.get();
      rocksFound = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print(e);
    }
    return rocksFound;
  }

  //returns list of all rocks found for a given UID JW
  Future<List<Map<String, dynamic>>> getRocksFoundForUID(String uid) async {
  List<Map<String, dynamic>> rocksFound = [];
  try {
    QuerySnapshot snapshot =
        await rocksFoundCollection.where('UID', isEqualTo: uid).get();
    rocksFound = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return {
        ...data,
        'ID': doc.id,
      };
    }).toList();
  } catch (e) {
    print(e);
  }
  return rocksFound;
}
   
  //Updates a given rock found, not currently used or needed should be removed JW
  Future<void> updateRockFound(String documentId, String uid,
      String rockClassification, String rockImageUrl, bool viewable) async {
    try {
      await rocksFoundCollection.doc(documentId).update({
        'UID': uid,
        'ROCK_CLASSIFICATION': rockClassification,
        'ROCK_IMAGE_URL': rockImageUrl,
        'VIEWABLE': viewable,
      });
    } catch (e) {
      print(e);
    }
  }

  //Hides rock found for user toggle JW
  Future<void> hideRockFound(String documentId) async {
    try {
      await rocksFoundCollection.doc(documentId).update({
        'VIEWABLE': false,
      });
    } catch (e) {
      print(e);
    }
  }
  
  //Shows rock found for user toggle JW
  Future<void> showRockFound(String documentId) async {
    try {
      await rocksFoundCollection.doc(documentId).update({
        'VIEWABLE': true,
      });
    } catch (e) {
      print(e);
    }
  }

  //Deletes a given rock found JW
  Future<void> deleteRockFound(String documentId) async {
    try {
      await rocksFoundCollection.doc(documentId).delete();
    } catch (e) {
      print(e);
    }
  }

  //Upload image to Firebase Storage and returns url to be saved with rock found document JW
  Future<String> uploadImageToStorage(File imageFile) async {
    String imageId = Uuid().v4();
    Reference storageReference =
        FirebaseStorage.instance.ref().child('images/$imageId.jpg');

    try {
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() {});
      String imageUrl = await storageSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print(e);
      return '';
    }
  }

  //Update given rock found with new image url, not currently used or needed JW
  Future<void> updateRockImageUrl(String rockId, String imageUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection('rocks_found')
          .doc(rockId)
          .update({'ROCK_IMAGE_URL': imageUrl});
      print('ROCK_IMAGE_URL updated successfully');
    } catch (e) {
      print(e);
    }
  }

  // Returns list of all rocks found for a given UID that are viewable JW
Future<List<Map<String, dynamic>>> getViewableRocksFoundForUID(String uid) async {
  List<Map<String, dynamic>> rocksFound = [];
  try {
    QuerySnapshot snapshot = await rocksFoundCollection
        .where('UID', isEqualTo: uid)
        .where('VIEWABLE', isEqualTo: true)
        .get();
    rocksFound = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return {
        ...data,
        'ID': doc.id,
      };
    }).toList();
  } catch (e) {
    print(e);
  }
  return rocksFound;
}

// Returns list of all rocks found that are viewable JW
Future<List<Map<String, dynamic>>> getAllViewableRocksFound(String uid) async {
  List<Map<String, dynamic>> rocksFound = [];
  try {
    QuerySnapshot snapshot = await rocksFoundCollection
        .where('VIEWABLE', isEqualTo: true)
        .get();
    rocksFound = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return {
        ...data,
        'ID': doc.id,
      };
    }).toList();
  } catch (e) {
    print(e);
  }
  return rocksFound;
}

}
