import 'package:cloud_firestore/cloud_firestore.dart';

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
}