// Copyright (c) 2022 Kodeco LLC

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
// distribute, sublicense, create a derivative work, and/or sell copies of the
// Software in any work that is designed, intended, or marketed for pedagogical
// or instructional purposes related to programming, coding,
// application development, or information technology.  Permission for such use,
// copying, modification, merger, publication, distribution, sublicensing,
// creation of derivative works, or sale is expressly withheld.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:rockid/classifier/rock_view.dart';
import '../classifier/classifier.dart';
import '../classifier/styles.dart';
import 'package:rockid/pages/profile_page.dart';
import 'package:rockid/pages/camera_page.dart';
import 'package:rockid/pages/Home_page.dart';
import 'package:geolocator/geolocator.dart';
import '../data/rocksfound.dart';

const _labelsFileName = 'assets/labels.txt';
const _modelFileName = '78%.tflite';

final RocksFoundCRUD rocksFoundCRUD = RocksFoundCRUD();
final user = FirebaseAuth.instance.currentUser!;

final List<Widget> _pages = [
  const HomePage(),
  const RockID(),
  const ProfilePage(),
];

class RockID extends StatefulWidget {
  const RockID({super.key});

  @override
  State<RockID> createState() => _RockIDState();
}

enum _ResultStatus {
  notStarted,
  notFound,
  found,
}

class _RockIDState extends State<RockID> {
  bool hasBeenSaved = false;
  bool _isAnalyzing = false;
  bool isRockClassified = false;
  final picker = ImagePicker();
  File? _selectedImageFile;

  // Result
  _ResultStatus _resultStatus = _ResultStatus.notStarted;
  String _RockLabel = ''; // Name of Error Message
  double _accuracy = 0.0;

  late Classifier _classifier;

  @override
  void initState() {
    super.initState();
    _loadClassifier();
  }

  Future<void> _loadClassifier() async {
    debugPrint(
      'Start loading of Classifier with '
      'labels at $_labelsFileName, '
      'model at $_modelFileName',
    );

    final classifier = await Classifier.loadWith(
      labelsFileName: _labelsFileName,
      modelFileName: _modelFileName,
    );
    _classifier = classifier!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Rock Identifier',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: Container(
        color: Color.fromARGB(255, 255, 237, 223),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(top: 30),
            ),
            const SizedBox(height: 20),
            _buildPhotolView(),
            const SizedBox(height: 10),
            _buildResultView(),
            const SizedBox(height: 10),
            Visibility(
              visible: _resultStatus == _ResultStatus.found,
              child: _buildSaveButton(),
            ),
            const Spacer(flex: 5),
            _buildPickPhotoButton(
              title: 'Take a photo',
              source: ImageSource.camera,
            ),
            _buildPickPhotoButton(
              title: 'Upload from gallery',
              source: ImageSource.gallery,
            ),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera, color: Colors.brown),
            label: 'Rock Identifier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.grey),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          // Update the state and rebuild the widget
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => _pages[index]),
          );
        },
      ),
    );
  }

  Widget _buildPhotolView() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        RockPhotoView(file: _selectedImageFile),
        _buildAnalyzingText(),
      ],
    );
  }

  Widget _buildAnalyzingText() {
    if (_isAnalyzing == false) {
      return const SizedBox.shrink();
    }
    return const CircularProgressIndicator();
  }

  Widget _buildTitle() {
    return const Text(
      'Rock Idenitifier',
      style: kTitleTextStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPickPhotoButton({
    required ImageSource source,
    required String title,
  }) {
    return TextButton(
      onPressed: () => _onPickPhoto(source),
      child: Container(
        width: 300,
        height: 50,
        color: kColorbrown,
        child: Center(
            child: Text(title,
                style: const TextStyle(
                  fontFamily: kButtonFont,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: kColorLightbeige,
                ))),
      ),
    );
  }

  void _setAnalyzing(bool flag) {
    setState(() {
      _isAnalyzing = flag;
    });
  }

  void _onPickPhoto(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile == null) {
      return;
    }

    final imageFile = File(pickedFile.path);
    setState(() {
      _selectedImageFile = imageFile;
    });

    _analyzeImage(imageFile);
  }

  void _analyzeImage(File image) {
    _setAnalyzing(true);
    hasBeenSaved = false;
    isRockClassified = false;

    final imageInput = img.decodeImage(image.readAsBytesSync())!;

    final resultCategory = _classifier.predict(imageInput);

    final result = resultCategory.score >= 0.8
        ? _ResultStatus.found
        : _ResultStatus.notFound;
    isRockClassified = true;
    final plantLabel = resultCategory.label;
    final accuracy = resultCategory.score;

    Future.delayed(Duration(seconds: 2), () {
      _setAnalyzing(false);

      setState(() {
        _resultStatus = result;
        _RockLabel = plantLabel;
        _accuracy = accuracy;
      });
    });
  }

  Widget _buildResultView() {
    var title = '';

    if (_resultStatus == _ResultStatus.notFound) {
      title = 'Fail to recognise';
    } else if (_resultStatus == _ResultStatus.found) {
      title = "This rock is possibly a $_RockLabel";
    } else {
      title = '';
    }

    //
    var accuracyLabel = '';
    if (_resultStatus == _ResultStatus.found) {
      accuracyLabel = 'Accuracy: ${(_accuracy * 100).toStringAsFixed(2)}%';
    }

    return Column(
      children: [
        Text(title, style: kResultTextStyle),
        const SizedBox(height: 10),
        Text(accuracyLabel, style: kResultRatingTextStyle),
      ],
    );
  }

  Widget _buildSaveButton() {
    if (!isRockClassified) {
      return SizedBox.shrink();
    }

    return ElevatedButton(
      onPressed: _saveClassification,
      child: Text('Save Classification'),
      style: ElevatedButton.styleFrom(
        primary: kColorbrown,
      ),
    );
  }

  void _saveClassification() {
    if (hasBeenSaved) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Classification Saved'),
            content: Text('You have already saved this classification.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      hasBeenSaved = true;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Save Classification'),
            content: Text(
                'Do you want to save your location along with the classification?'),
            actions: <Widget>[
              TextButton(
                child: Text('No'),
                onPressed: () {
                  _saveClassificationWithoutLocation();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  _saveClassificationWithLocation();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _saveClassificationWithoutLocation() async {
    final imageUrl =
        await rocksFoundCRUD.uploadImageToStorage(_selectedImageFile!);
    rocksFoundCRUD.addRockFoundWithOutLocation(
        user.uid, _RockLabel, imageUrl, DateTime.now());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Classification Saved'),
          content: Text(
              'The classification and your location have been saved successfully.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _saveClassificationWithLocation() async {
    final position = await Geolocator.getCurrentPosition();
    final latitude = position.latitude;
    final longitude = position.longitude;

    final imageUrl =
        await rocksFoundCRUD.uploadImageToStorage(_selectedImageFile!);

    rocksFoundCRUD.addRockFoundWithLocation(
        user.uid, _RockLabel, imageUrl, latitude, longitude, DateTime.now());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Classification Saved'),
          content: Text(
              'The classification and your location have been saved successfully.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
