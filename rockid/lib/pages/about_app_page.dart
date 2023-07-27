import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rockid/classifier/styles.dart';

import '../components/hamburger_menu.dart';

class AboutAppPage extends StatelessWidget {
  final String appName = "Rock ID";
  final String appVersion = "1.0.0";

  final List<SectionData> sections = [
    SectionData(
      title: "Identifying Rocks",
      description: "Rocks can be classified using your phones camera or image gallery. After a successful classification, you have the option of saving the rock to your collection. At the time you save the rock to your collection you can also save your location so that your rock will be visible to other users in the map.",
    ),
    SectionData(
      title: "Managing Rocks",
      description: "You can manage rocks that you have identified and saved to your collection. You can view your rocks, edit their viewability on the map, and delete them from your collection all withing the 'My Collection' page.",
    ),
    SectionData(
      title: "Using Maps Functionality",
      description: "In the 'Rocks Around the World' page you will be able to see the locations where other users have discovered rocks. From each marker on the map you will be able to view that users profile who discovered the rock.",
    ),
    SectionData(
      title: "Managing User Profile",
      description: "You can edit your profile by selecting the edit profile button in the profile page. You can also manage the priacy settings of your full name, email, and phone number from this page. If you would like to make your entire profile private this can be accomplised from the settigns tab in the Hamburger Menu.",
    ),
    SectionData(
      title: "Viewing Rock Information",
      description: "You can view rock information for each rock that the classifier is able to identify throug the rock information pageq.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About the App"),
        backgroundColor: ForegroundColor,
      ),
      endDrawer: HamburgerMenu(),
      body: Container(
        color: backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: ListView(
          children: [
            Center(
              child: Text(
                appName,
                style: GoogleFonts.ptSans(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                "Version $appVersion",
                style: GoogleFonts.ptSans(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            Divider(), 
            SizedBox(height: 10),
            for (var section in sections) ...[
              Text(
                section.title,
                style: GoogleFonts.ptSans(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 5),
              Text(
                section.description,
                style: GoogleFonts.ptSans(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class SectionData {
  final String title;
  final String description;

  SectionData({required this.title, required this.description});
}
