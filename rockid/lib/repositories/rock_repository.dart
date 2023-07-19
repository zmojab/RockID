import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/rock.dart';

class RockRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Rock>> getRocks() async {
    final snapshot = await _firestore.collection('rock_information').get();
    final rockList = snapshot.docs.map((doc) {
      final rockData = doc.data();
      return Rock.fromFirestore(rockData);
    }).toList();
    return rockList;
  }
  
  Future<Rock> getRockByClassification(String rockId) async {
    final snapshot = await _firestore.collection('rock_information').doc(rockId).get();
    final rockData = snapshot.data();
      return Rock.fromFirestore(rockData!);
  }
}
