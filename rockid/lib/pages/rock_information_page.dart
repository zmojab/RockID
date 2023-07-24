import 'package:flutter/material.dart';
import '../models/rock.dart';
import '../repositories/rock_repository.dart';
import '../components/rock_details_popup.dart';

class RockInformationPage extends StatefulWidget {
  @override
  _RockInformationPageState createState() => _RockInformationPageState();
}

class _RockInformationPageState extends State<RockInformationPage> {
  List<Rock> allRocks = [];
  List<Rock> displayedRocks = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchRocks();
  }

  // Fetches all rocks from the repository
  Future<void> fetchRocks() async {
    final rocks = await RockRepository().getRocks();
    setState(() {
      allRocks = rocks;
      displayedRocks = rocks;
    });
  }

  // Filters the rocks based on the search term entered by the user
  void _filterRocks(String searchTerm) {
    setState(() {
      displayedRocks = allRocks
          .where((rock) =>
              rock.name.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rock Information',
          style: TextStyle(fontSize: 30)
        ),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: Container(
        child: Column(
          children: [
            // Search bar for filtering rocks
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filterRocks,
                decoration: const InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            // Scrollable list of rocks
            Expanded(
              child: ListView.builder(
                itemCount: displayedRocks.length,
                itemBuilder: (BuildContext context, int index) {
                  final rock = displayedRocks[index];
                  return ListTile(
                    title: Text(rock.name),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return RockDetailsPopup(rock: rock);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        )
      ),
    );
  }
}
