import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'other_user_profile_page.dart'; in my branch now

const LatLng currentLocation = LatLng(42.3314, -83.0458);

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};

  void createMarkers(QuerySnapshot snapshot) {
    for (int i = 0; i < snapshot.docs.length; i++) {
      var doc = snapshot.docs[i];
      var data = doc.data() as Map<String, dynamic>;
      var markerIdVal = doc.id;
      var markerId = MarkerId(markerIdVal);
      var marker = Marker(
        markerId: markerId,
        position: LatLng(data['LATTITUDE'], data['LONGITUDE']),
        infoWindow: InfoWindow(
          title: data['ROCK_CLASSIFICATION'],
          snippet: data['CITY'],
        ),
        //to go to the other user's profile page from the map icon.
        //     onTap: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       //present in my branch for when to go to the other user's profile page from the map icon.
        //       builder: (context) => OtherUserProfilePage(uid: data['UID']),
        //     ),
        //   );
        // },
      );
      //explicitly setting the state, the markers may have been added too late otherwise
      setState(() {
        markers.add(marker);
      });
    }
  }

  getMarkerData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('rocks_found')
        .where('VIEWABLE', isEqualTo: true)
        .where('CAN_BE_VIEWED', isEqualTo: true)
        .get();
    createMarkers(snapshot);
  }

  @override
  void initState() {
    super.initState();
    getMarkerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: currentLocation,
          zoom: 10,
        ),
        markers: markers,
        onMapCreated: (controller) {
          mapController = controller;
        },
      ),
    );
  }
}
