import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/rocksfound.dart';

class RocksFoundListPage extends StatefulWidget {
  //final user = FirebaseAuth.instance.currentUser!;
  final String uid;

  RocksFoundListPage({required this.uid});

  @override
  _RocksFoundListPageState createState() => _RocksFoundListPageState();
}

class _RocksFoundListPageState extends State<RocksFoundListPage> {
  RocksFoundCRUD rocksFoundCRUD = RocksFoundCRUD();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rocks Found')),
      body: Container(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: rocksFoundCRUD.getRocksFoundForUID(widget.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Map<String, dynamic>> rocksFound = snapshot.data!;
              return ListView.builder(
                itemCount: rocksFound.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> rockFound = rocksFound[index];
                  return ListTile(
                    leading: Image.network(
                      rockFound['ROCK_IMAGE_URL'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(rockFound['ROCK_CLASSIFICATION']),
                   // subtitle: Text(rockFound['ROCK_IMAGE_URL']),
                    trailing: Text(rockFound['VIEWABLE'].toString()),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
