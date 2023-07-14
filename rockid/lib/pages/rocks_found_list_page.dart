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

  //Used to refresh page after operation JW
  void refreshRocksFound() {
    setState(() {
      rocksFoundFuture = rocksFoundCRUD.getRocksFoundForUID(widget.uid);
    });
  }
  

  //Rock classification names are stored in firebase in all lower case
  //This function capitalizes the first letter of each word in the rock classification name for presentation in the list tile JW
  String capitalizeRockClassification(String rockClassificaitonName) {
  if (rockClassificaitonName.isEmpty) return rockClassificaitonName;

  final List<String> rockClassificationNames = rockClassificaitonName.split(" ");
  final capitalizedWords = rockClassificationNames.map((rockClassificationPartName) {
    if (rockClassificationPartName.isEmpty) return rockClassificationPartName;
    return rockClassificationPartName[0].toUpperCase() + rockClassificationPartName.substring(1);
  });

  return capitalizedWords.join(" ");
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
                  // Dismissible for each rock found for slide to delete- JW
                  return Dismissible(
                    //unique key for each rock found JW
                      key: UniqueKey(), 
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Color.fromARGB(247, 242, 137, 38),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction) {
                        // Deletes from collection JW
                        rocksFoundCRUD
                            .deleteRockFound(rockFound['ID'])
                            .then((_) {
                          refreshRocksFound();
                        });
                        // Snackbar confirmation rock deleted JW
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Rock deleted'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: ListTile(
                        //ListTile for each rock found JW
                        leading: Image.network(
                          rockFound['ROCK_IMAGE_URL'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(capitalizeRockClassification(rockFound['ROCK_CLASSIFICATION'])),
                        subtitle: Text(
                            //Timestamp for when rock found JW
                            "Found: ${DateFormat('MM/dd/yyyy HH:mm').format(rockFound['DATETIME'].toDate())}" + 
                            (rockFound['CAN_BE_VIEWED'] ? "\nLatitude: ${rockFound['LATTITUDE']}\nLongitude: ${rockFound['LONGITUDE']}" : "")),
                        //popupmenu for each rock found JW
                        trailing: PopupMenuButton<String>(
                          //to show popup needs to be implemented still JW
                          onSelected: (value) {
                            if (value == 'view') {
                              // Placeholder to go to rock information page
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
                      ));
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
