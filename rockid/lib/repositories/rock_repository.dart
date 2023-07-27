import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../models/rock.dart';

class RockRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Rock>> getRocks() async {
    final snapshot = await _firestore.collection('rock_information').get();
    final rockList = await Future.wait(snapshot.docs.map((doc) async {
      final rockData = doc.data();
      final imageURL = rockData['URL'];
      if (imageURL != null && imageURL is DocumentReference) {
        rockData['URL'] = await fetchImageUrl(imageURL);
      }
      return Rock.fromFirestore(rockData);
    }));
    return rockList;
  }

  Future<Rock> getRockByClassification(String rockId) async {
    final snapshot =
        await _firestore.collection('rock_information').doc(rockId).get();
    final rockData = snapshot.data();
    final imageURL = rockData?['URL'];
    if (imageURL != null && imageURL is DocumentReference) {
      rockData?['URL'] = await fetchImageUrl(imageURL);
    }
    return Rock.fromFirestore(rockData!);
  }

  Future<String> fetchImageUrl(DocumentReference imageRef) async {
    try {
      final downloadURL =
          await firebase_storage.FirebaseStorage.instance.ref(imageRef.path).getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error fetching image URL: $e');
      return '';
    }
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/rock.dart';

// class RockRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<List<Rock>> getRocks() async {
//     final snapshot = await _firestore.collection('rock_information').get();
//     final rockList = snapshot.docs.map((doc) {
//       final rockData = doc.data();
//       return Rock.fromFirestore(rockData);
//     }).toList();
//     return rockList;
//   }
  
//   Future<Rock> getRockByClassification(String rockId) async {
//     final snapshot = await _firestore.collection('rock_information').doc(rockId).get();
//     final rockData = snapshot.data();
//     return Rock.fromFirestore(rockData!);
//   }
// }
