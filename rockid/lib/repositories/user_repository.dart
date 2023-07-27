import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User> getUserById(String uid) async {
    final snapshot = await _firestore
      .collection('users')
      .where('UID', isEqualTo: uid)
      .limit(1) // limit the query to return only one document
      .get();
    
    // Check if a document was found. If no document was found, return an anonymous user
    if (snapshot.docs.isEmpty) {
      return User(
        uid: '',
        username: '',
      );
    }

    // Only one document should match the query due to the UID uniqueness. So we take the first one.
    final userData = snapshot.docs.first.data();
    return User.fromFirestore(userData);
  }
}
