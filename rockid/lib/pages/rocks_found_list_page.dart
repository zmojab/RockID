import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/rocksfound.dart';

// For displaying list of rocks found by user JW
class RocksFoundListPage extends StatefulWidget {
  final String uid;

  //Uid passed in from home page JW
  RocksFoundListPage({required this.uid});

  @override
  _RocksFoundListPageState createState() => _RocksFoundListPageState();
}

class _RocksFoundListPageState extends State<RocksFoundListPage> {
  //For CRUD operations on rocks_found collection JW
  RocksFoundCRUD rocksFoundCRUD = RocksFoundCRUD();

  //For rocks found
  Future<List<Map<String, dynamic>>>? rocksFoundFuture;

  @override
  void initState() {
    super.initState();
    //As operations on rocks occur the page will be refreshed JW
    refreshRocksFound();
  }

  void refreshRocksFound() {
    setState(() {
      rocksFoundFuture = rocksFoundCRUD.getRocksFoundForUID(widget.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    //Scaffold for main container
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rocks Found List',
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
              // While waiting for data to load JW
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              // If data is loaded JW
              List<Map<String, dynamic>> rocksFound = snapshot.data!;
              return ListView.builder(
                //ListView to dicplay rocks found JW
                itemCount: rocksFound.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> rockFound = rocksFound[index];
                  //returns can be viewed, false if field doesnt exist JW
                  bool canBeViewed = rockFound['CAN_BE_VIEWED'] ?? false;
                  return ListTile(
                    //ListTile for each rock found JW
                    leading: Image.network(
                      rockFound['ROCK_IMAGE_URL'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(rockFound['ROCK_CLASSIFICATION']),
                    subtitle: Text(
                      //Timestamp for when rock found JW
                        "Found: ${DateFormat('MM/dd/yyyy HH:mm').format(rockFound['DATETIME'].toDate())}"),
                        //popupmenu for each rock found JW
                    trailing: PopupMenuButton<String>(
                      //to show popup needs to be implemented still JW
                      onSelected: (value) {
                        if (value == 'view') {
                          // Placeholder to go to rock information page
                        } else if (value == 'delete') {
                          //deletes rock found from database JW
                          rocksFoundCRUD
                              .deleteRockFound(rockFound['ID'])
                              .then((_) {
                            refreshRocksFound();
                          });
                        } else if (value == 'hide') {
                          //toggles viewable field to false JW
                          rocksFoundCRUD
                              .hideRockFound(rockFound['ID'])
                              .then((_) {
                            refreshRocksFound();
                          });
                        } else if (value == 'show') {
                          //toggles viewable field to true JW
                          rocksFoundCRUD
                              .showRockFound(rockFound['ID'])
                              .then((_) {
                            refreshRocksFound();
                          });
                        }
                      },
                      //options for popupmenu JW
                      itemBuilder: (BuildContext context) {
                        List<PopupMenuEntry<String>> menuItems = [
                          PopupMenuItem<String>(
                            value: 'view',
                            child: Text('View'),
                          ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ];
                        //only showed if rock can be viewed JW
                        if (canBeViewed) {
                          if (rockFound['VIEWABLE']) {
                            menuItems.add(
                              PopupMenuItem<String>(
                                value: 'hide',
                                child: Text('Hide in Map'),
                              ),
                            );
                          } else {
                            menuItems.add(
                              PopupMenuItem<String>(
                                value: 'show',
                                child: Text('Show in Map'),
                              ),
                            );
                          }
                        }

                        return menuItems;
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
