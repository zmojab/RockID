import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recently_found_rock.dart';

class RecentlyFoundRockRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<RecentlyFoundRock>> getRecentlyFoundRocks() async {
    final snapshot = await _firestore
        .collection('rocks_found')
        .where('CAN_BE_VIEWED', isEqualTo: true)
        .where('VIEWABLE', isEqualTo: true)
        .orderBy('DATETIME', descending: true)
        .get();

    final rocksList = snapshot.docs.map((doc) {
      final rockData = doc.data();
      return RecentlyFoundRock.fromFirestore(rockData); // use factory method to create rock object
    }).toList();

    return rocksList;
  }

  getMoreRecentlyFoundRocks(DocumentSnapshot<Object?>? lastDocument) {}
}