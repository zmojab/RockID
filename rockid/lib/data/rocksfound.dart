import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RocksFoundCRUD {
  final CollectionReference rocksFoundCollection =
      FirebaseFirestore.instance.collection('rocks_found');

  Future<void> addRockFound(String uid, String rockClassification,
      String rockImageUrl, bool viewable) async {
    try {
      await rocksFoundCollection.doc().set({
        'UID': uid,
        'ROCK_CLASSIFICATION': rockClassification,
        'ROCK_IMAGE_URL': rockImageUrl,
        'VIEWABLE': viewable,
      });
    } catch (e) {
      print(e);
    }
  }

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

  Future<List<Map<String, dynamic>>> getRocksFoundForUID(String uid) async {
    List<Map<String, dynamic>> rocksFound = [];
    try {
      QuerySnapshot snapshot = await rocksFoundCollection
          .where('UID', isEqualTo: uid)
          .get();
      rocksFound = snapshot.docs
      .map((doc) => doc.data() as Map<String, dynamic>)
      .toList();
    } catch (e) {
      print(e);
    }
    return rocksFound;
  }

  Future<void> updateRockFound(
    String documentId,
    String uid,
    String rockClassification,
    String rockImageUrl,
    bool viewable) async {
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

  Future<void> deleteRockFound(String documentId) async {
    try {
      await rocksFoundCollection.doc(documentId).delete();
    } catch (e) {
      print(e);
    }
  }

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

}