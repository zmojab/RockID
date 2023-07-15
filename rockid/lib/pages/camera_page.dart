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

const _labelsFileName = 'assets/polishedLabels.txt';
const _modelFileName = 'polished80%.tflite';
const _labelsFileName1 = 'assets/roughLabels.txt';
const _modelFileName1 = 'rough82%.tflite';

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
  bool _isLocation = false;
  bool _isRaw = false;
  bool isRockClassified = false;
  final picker = ImagePicker();
  File? _selectedImageFile;
  String _rockType = "";

  // Result
  _ResultStatus _resultStatus = _ResultStatus.notStarted;
  String _RockLabel = ''; // Name of Error Message
  double _accuracy = 0.0;

  //creates Classifier objects
  late Classifier _classifier;
  late Classifier _classifier1;

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
    //loads polished gems
    final classifier = await Classifier.loadWith(
      labelsFileName: _labelsFileName,
      modelFileName: _modelFileName,
    );
    _classifier = classifier!;
    //loads rough gems
    final classifier1 = await Classifier.loadWith(
      labelsFileName: _labelsFileName1,
      modelFileName: _modelFileName1,
    );
    _classifier1 = classifier1!;
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
              padding: EdgeInsets.only(top: 10),
            ),
            const SizedBox(height: 10),
            _buildPhotolView(),
            const SizedBox(height: 10),
            const Spacer(),
            const Text(
              "Save Location",
              style: TextStyle(
                  color: Colors.brown,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            _buildLocationSwitch(),
            const Spacer(flex: 2),
            const Text(
              "Rock Type",
              style: TextStyle(
                  color: Colors.brown,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            _buildRockRadio(),
            const Spacer(),
            // only visible when the result is found - JW

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
            icon: Icon(Icons.gps_fixed_sharp, color: Colors.brown),
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

  Widget _buildRockRadio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: RadioListTile(
            title: const Text(
              "Rough",
              style: TextStyle(color: Colors.brown, fontSize: 15),
            ),
            value: true,
            activeColor: Colors.brown,
            groupValue: _isRaw,
            onChanged: (value) {
              setState(() {
                _isRaw = value!;
              });
            },
          ),
        ),
        Expanded(
          child: RadioListTile(
            title: const Text(
              "Polished",
              style: TextStyle(color: Colors.brown, fontSize: 15),
            ),
            activeColor: Colors.brown,
            value: false,
            groupValue: _isRaw,
            onChanged: (value) {
              setState(() {
                _isRaw = value!;
              });
            },
          ),
        ),
      ],
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
    String rockType = "";
    _setAnalyzing(true);
    // flag to ensure rock is not saved again
    //hasBeenSaved = false;
    // flag to ensure rock classified
    isRockClassified = false;
    final resultCategory;
    final imageInput = img.decodeImage(image.readAsBytesSync())!;
    if (_isRaw) {
      resultCategory = _classifier1.predict(imageInput);
      rockType = "rough";
    } else {
      resultCategory = _classifier.predict(imageInput);
      rockType = "polished";
    }

    final result = resultCategory.score >= 0.8
        ? _ResultStatus.found
        : _ResultStatus.notFound;
    isRockClassified = true;
    final rockLabel = resultCategory.label;
    final accuracy = resultCategory.score;

    Future.delayed(Duration(seconds: 2), () {
      _setAnalyzing(false);
    });

    setState(() {
      _resultStatus = result;
      _RockLabel = rockLabel;
      _accuracy = accuracy;
      _rockType = rockType;
    });
    if (_resultStatus == _ResultStatus.found) {
      _SaveRock();
    } else {
      _CantRecognize();
    }
  }

  //Adds rock to database without location - JW
  void _saveClassificationWithOrWithoutLocation() async {
    //upload image to storage - JW
    //Get lat and long form Geolocator - JW
    final position = await Geolocator.getCurrentPosition();
    final latitude = position.latitude;
    final longitude = position.longitude;
    final imageUrl =
        await rocksFoundCRUD.uploadImageToStorage(_selectedImageFile!);

    if (_isLocation) {
      try {
        rocksFoundCRUD.addRockFoundWithLocation(user.uid, _RockLabel, imageUrl,
            latitude, longitude, DateTime.now());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Successfully saved the rock classification and location')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to save rock classification and location')),
        );
      }
    } else {
      try {
        rocksFoundCRUD.addRockFoundWithOutLocation(
            user.uid, _RockLabel, imageUrl, DateTime.now());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Successfully saved the rock classification')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save rock classification')),
        );
      }
    }
  }

  void _SaveRock() async {
    //Get lat and long form Geolocator - JW
    final position = await Geolocator.getCurrentPosition();
    final latitude = position.latitude;
    final longitude = position.longitude;
    var title = '';

    if (_resultStatus == _ResultStatus.notFound) {
      title = 'Fail to recognise this rock';
    } else if (_resultStatus == _ResultStatus.found) {
      title = "This rock is possibly a $_rockType $_RockLabel";
    } else {
      title = '';
    }
    var accuracyLabel = '';
    if (_resultStatus == _ResultStatus.found) {
      accuracyLabel = '${(_accuracy * 100).toStringAsFixed(2)}%';
    }
    //upload image to storage - JW

    //Confirmation
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 255, 237, 223),
          title: Text('Rock Classification'),
          content: Text(title + " with an accuracy of " + accuracyLabel),
          actions: <Widget>[
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.brown),
                  ),
                  onPressed: () {
                    _saveClassificationWithOrWithoutLocation();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.brown),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _CantRecognize() async {
    //Get lat and long form Geolocator - JW
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 255, 237, 223),
          title: Text('Rock Classification'),
          content: Text("Failed to recognize the rock"),
          actions: <Widget>[
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text(
                    'Close',
                    style: TextStyle(color: Colors.brown),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildLocationSwitch() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Off', style: TextStyle(color: Colors.brown)),
            Switch(
              value: _isLocation,
              activeColor: Colors.brown,
              onChanged: (value) {
                print("VALUE : $value");
                setState(() {
                  _isLocation = value;
                });
              },
            ),
            Text('On', style: TextStyle(color: Colors.brown)),
          ],
        ),
      ],
    );
  }
}
