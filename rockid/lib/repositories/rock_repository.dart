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
}
