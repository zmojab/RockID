import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import '../data/rocksfound.dart';
import '../data/users.dart';
import '../models/rock.dart';
import '../repositories/rock_repository.dart';
import '../components/rock_details_popup.dart';

class OtherUsersRocksPage extends StatefulWidget {
  final String uid;

  OtherUsersRocksPage({required this.uid});

  @override
  _OtherUsersRocksPageState createState() => _OtherUsersRocksPageState();
}

class _OtherUsersRocksPageState extends State<OtherUsersRocksPage> {
  RocksFoundCRUD rocksFoundCRUD = RocksFoundCRUD();
  UserCRUD userCRUD = UserCRUD();
  RockRepository rockRepository = RockRepository();

  Future<List<Map<String, dynamic>>>? rocksFoundFuture;
  String _username = '';

  @override
  void initState() {
    super.initState();
    setPage();
  }

  void setPage() async {
    final rocksFound = await getRocksFoundWithCity(widget.uid);
    final username = await userCRUD.getUsernameFromUid(widget.uid);

    setState(() {
      rocksFoundFuture = Future.value(rocksFound);
      _username = username ?? '';
    });
  }

  Future<List<Map<String, dynamic>>> getRocksFoundWithCity(String uid) async {
    List<Map<String, dynamic>> rocksFound =
        await rocksFoundCRUD.getViewableRocksFoundForUID(uid);
    for (Map<String, dynamic> rock in rocksFound) {
      double? latitude = rock['LATTITUDE'];
      double? longitude = rock['LONGITUDE'];
      String city = await getCityFromCoordinates(latitude, longitude);
      rock['CITY'] = city;
    }
    return rocksFound;
  }

  Future<String> getCityFromCoordinates(
      double? latitude, double? longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude!, longitude!);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        return placemark.locality ?? '';
      }
    } catch (e) {
      print('Error: $e');
    }
    return '';
  }

  void showRockInformation(String rockClassificaiton, BuildContext context) {
    Future<Rock> rockFuture = rockRepository
        .getRockByClassification(capitalizeRockClassification(rockClassificaiton));
    rockFuture.then((rock) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return FutureBuilder<Rock>(
            future: rockFuture as Future<Rock>,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return RockDetailsPopup(rock: snapshot.data!);
              } else {
                return Text('No data found');
              }
            },
          );
        },
      );
    });
  }

  String capitalizeRockClassification(String rockClassificaitonName) {
    if (rockClassificaitonName.isEmpty) return rockClassificaitonName;

    final List<String> rockClassificationNames =
        rockClassificaitonName.split(" ");
    final capitalizedWords = rockClassificationNames
        .map((rockClassificationPartName) =>
            rockClassificationPartName.isNotEmpty
                ? rockClassificationPartName[0].toUpperCase() +
                    rockClassificationPartName.substring(1)
                : rockClassificationPartName);

    return capitalizedWords.join(" ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$_username's Rocks",
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: Container(
        color: Color.fromARGB(255, 255, 237, 223),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: rocksFoundFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              List<Map<String, dynamic>> rocksFound = snapshot.data!;
              return ListView.builder(
                itemCount: rocksFound.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> rockFound = rocksFound[index];
                  double latitude = rockFound['LATTITUDE']!;
                  double longitude = rockFound['LONGITUDE']!;
                  return ListTile(
                    leading: Image.network(
                      rockFound['ROCK_IMAGE_URL']!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      capitalizeRockClassification(
                          rockFound['ROCK_CLASSIFICATION']!),
                    ),
                    subtitle: Text(
                      "Found: ${DateFormat('MM/dd/yyyy HH:mm').format(rockFound['DATETIME']!.toDate())}\nCity: ${rockFound['CITY'] ?? 'Unknown'}",
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'view') {
                           showRockInformation(
                                rockFound['ROCK_CLASSIFICATION'], context);
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem<String>(
                            value: 'view',
                            child: Text('View'),
                          ),
                        ];
                      },
                    ),
                  );
                },
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}