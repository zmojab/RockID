import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/rocksfound.dart';

class RocksFoundListPage extends StatefulWidget {
  final String uid;

  RocksFoundListPage({required this.uid});

  @override
  _RocksFoundListPageState createState() => _RocksFoundListPageState();
}

class _RocksFoundListPageState extends State<RocksFoundListPage> {
  RocksFoundCRUD rocksFoundCRUD = RocksFoundCRUD();
  Future<List<Map<String, dynamic>>>? rocksFoundFuture;

  @override
  void initState() {
    super.initState();
    refreshRocksFound();
  }

  void refreshRocksFound() {
    setState(() {
      rocksFoundFuture = rocksFoundCRUD.getRocksFoundForUID(widget.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(
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
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              List<Map<String, dynamic>> rocksFound = snapshot.data!;
              return ListView.builder(
                itemCount: rocksFound.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> rockFound = rocksFound[index];
                  bool canBeViewed = rockFound['CAN_BE_VIEWED'] ?? false;
                  return ListTile(
                    leading: Image.network(
                      rockFound['ROCK_IMAGE_URL'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(rockFound['ROCK_CLASSIFICATION']),
                    subtitle: Text("Found: ${DateFormat('dd/MM/yyyy HH:mm').format(rockFound['DATETIME'].toDate())}"),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'view') {
                          // Placeholder to go to rock information page
                        } else if (value == 'delete') {
                          rocksFoundCRUD.deleteRockFound(rockFound['ID']).then((_) {
                            refreshRocksFound();
                          });
                        } else if (value == 'hide') {
                          rocksFoundCRUD.hideRockFound(rockFound['ID']).then((_) {
                            refreshRocksFound();
                          });
                        } else if (value == 'show') {
                          rocksFoundCRUD.showRockFound(rockFound['ID']).then((_) {
                            refreshRocksFound();
                          });
                        }
                      },
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
                        if (canBeViewed) {
                          if(rockFound['VIEWABLE']) {
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
