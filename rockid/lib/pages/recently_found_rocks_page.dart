import 'package:flutter/material.dart';
import 'package:rockid/classifier/styles.dart';
import 'package:rockid/pages/other_user_profile_page.dart';
import '../models/recently_found_rock.dart';
import '../models/user.dart';
import '../repositories/recently_found_rock_repository.dart';
import '../repositories/user_repository.dart';

class RecentlyFoundRocksPage extends StatefulWidget {
  @override
  _RecentlyFoundRocksPageState createState() => _RecentlyFoundRocksPageState();
}

String capitalize(String text) {
  if (text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1);
}

class _RecentlyFoundRocksPageState extends State<RecentlyFoundRocksPage> {
  List<RecentlyFoundRock> recentlyFoundRocks = [];

  @override
  void initState() {
    super.initState();
    fetchRecentlyFoundRocks();
  }

  // Fetches the recently found rocks from the repository
  Future<void> fetchRecentlyFoundRocks() async {
    final rocks = await RecentlyFoundRockRepository().getRecentlyFoundRocks();
    setState(() {
      recentlyFoundRocks = rocks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Recently Found Rocks'),
        backgroundColor: ForegroundColor,
      ),
      body: ListView.builder(
        itemCount: recentlyFoundRocks.length,
        itemBuilder: (context, index) {
          final rock = recentlyFoundRocks[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<User>(
                  future: UserRepository().getUserById(rock.uid),
                  builder:
                      (BuildContext context, AsyncSnapshot<User> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            // Wrap the username Text with GestureDetector
                            onTap: () {
                              // Navigate to the user profile page here
                              // You can use Navigator.push() to navigate to the profile page
                              // For example:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OtherUserProfilePage(uid: rock.uid),
                                ),
                              );
                            },
                            child: Text(
                              snapshot.data?.username ?? 'Anonymous User',
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              '${capitalize(rock.rockClassification)} | ${rock.city}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 50),
                child: Image.network(rock.rockImageUrl),
              ),
            ],
          );
        },
      ),
    );
  }
}
