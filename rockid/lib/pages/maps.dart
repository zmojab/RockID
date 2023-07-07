import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//added google maps package - SU

//location of detroit for the pin that will be using this location to populate infomration on rock, this location will change to current location - SU
const LatLng currentLocation = LatLng(42.3314, -83.0458);


//page initiation 
class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController mapController;
  Set<Marker> markers = Set<Marker>();


  
  @override
  void initState() {
    super.initState();
    markers.add(
      Marker(
        markerId: MarkerId('locationMarker'), //initiate marker which will be later populated by the lat and long of found rocks - SU
        position: currentLocation,
        onTap: () { //marker info which will be given by rock information page, this will also show user who found the rock (if stated true) - SU
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Marker Title'),
              content: Text('Marker Description'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  //map initial state with control - SU
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
