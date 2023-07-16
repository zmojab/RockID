import 'package:flutter/material.dart';

class DisclaimerPopup {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Disclaimer'),
          content: const Text('This application is intended for hobbyists and results provided by the application should not be used in any professional setting. The information and identification of rocks provided by this app are for general reference only and should not be considered as professional advice. Always consult with experts or professionals in the field for accurate and reliable information.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}