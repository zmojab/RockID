import 'package:cloud_firestore/cloud_firestore.dart';

class RecentlyFoundRock {
  final bool canBeViewed;
  final String city;
  final Timestamp dateTime;
  final double latitude;
  final double longitude;
  final String rockClassification;
  final String rockImageUrl;
  final String uid;
  final bool viewable;

  RecentlyFoundRock({
    required this.canBeViewed,
    required this.city,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
    required this.rockClassification,
    required this.rockImageUrl,
    required this.uid,
    required this.viewable,
  });

  factory RecentlyFoundRock.fromFirestore(Map<String, dynamic> data) {
    return RecentlyFoundRock(
      canBeViewed: data['CAN_BE_VIEWED'] ?? false,
      city: data['CITY'] ?? '',
      dateTime: data['DATETIME'] is Timestamp ? (data['DATETIME'] as Timestamp) : Timestamp.now(),
      latitude: data['LATTITUDE'] ?? 0.0,
      longitude: data['LONGITUDE'] ?? 0.0,
      rockClassification: data['ROCK_CLASSIFICATION'] ?? '',
      rockImageUrl: data['ROCK_IMAGE_URL'] ?? '',
      uid: data['UID'] ?? '',
      viewable: data['VIEWABLE'] ?? false,
    );
  }

  DocumentSnapshot<Object?>? get doc => null;
}
