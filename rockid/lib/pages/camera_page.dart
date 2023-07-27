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
import 'package:geocoding/geocoding.dart';
import '../components/hamburger_menu.dart';
import '../data/rocksfound.dart';

const _labelsFileName = 'assets/polishedLabels.txt';
const _modelFileName = 'MobileNetPolished80%.tflite';
const _labelsFileName1 = 'assets/roughLabels.txt';
const _modelFileName1 = 'mobileNet2Rough80%.tflite';
const _labelsFileName2 = 'assets/RoughOrPolished.txt';
const _modelFileName2 = 'RoughOrPolished97%.tflite';
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
  final picker = ImagePicker();
  File? _selectedImageFile;
  String _rockType = "";
  String _chance = "";
  //String _city = '';

  // Result
  _ResultStatus _resultStatus = _ResultStatus.notStarted;
  String _RockLabel = ''; // Name of Error Message
  double _accuracy = 0.0;

  //creates Classifier objects
  late Classifier _classifier;
  late Classifier _classifier1;
  late Classifier _classifier2;

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
    //loads rough or polished model
    final classifier2 = await Classifier.loadWith(
      labelsFileName: _labelsFileName2,
      modelFileName: _modelFileName2,
    );
    _classifier2 = classifier2!;
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
        backgroundColor: ForegroundColor,
      ),
      endDrawer: HamburgerMenu(),
      body: Container(
        color: backgroundColor,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Save Location?",
                  style: TextStyle(
                      color: ForegroundColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                _buildLocationSwitch(),
              ],
            ),
            const Spacer(flex: 2),
            _buildImageButton(
              title: 'Take a Photo',
              icon: Icons.camera_alt,
              onPressed: () => _onPickPhoto(ImageSource.camera),
            ),
            const Spacer(),
            _buildImageButton(
              title: 'Upload From Gallery',
              icon: Icons.photo_library,
              onPressed: () => _onPickPhoto(ImageSource.gallery),
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
            icon: Icon(Icons.gps_fixed_sharp, color: ForegroundColor),
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

  Widget _buildImageButton({
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
    double buttonWidth = 270,
  }) {
    return SizedBox(
      width: buttonWidth,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ForegroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontFamily: kButtonFont,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: kColorLightbeige,
                ),
              ),
            ],
          ),
        ),
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
    String chance = "";
    final resultCategory;
    final imageInput = img.decodeImage(image.readAsBytesSync())!;
    _setAnalyzing(true);
    final roughOrPolishedResults = _classifier2.predict(imageInput);
    print(roughOrPolishedResults.label);
    if (roughOrPolishedResults.label == "rough") {
      resultCategory = _classifier1.predict(imageInput);
      rockType = "rough";
    } else {
      resultCategory = _classifier.predict(imageInput);
      rockType = "polished";
    }

    final result = resultCategory.score >= 0.75
        ? _ResultStatus.found
        : _ResultStatus.notFound;
    final rockLabel = resultCategory.label;
    final accuracy = resultCategory.score;

    if (accuracy >= .95) {
      chance = "high";
    } else if (accuracy >= .85) {
      chance = "medium";
    } else {
      chance = "low";
    }

    Future.delayed(Duration(seconds: 2), () {
      _setAnalyzing(false);
    });

    setState(() {
      _chance = chance;
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

  void _saveClassificationWithOrWithoutLocation() async {
    final position = await Geolocator.getCurrentPosition();
    final latitude = position.latitude;
    final longitude = position.longitude;
    final imageUrl =
        await rocksFoundCRUD.uploadImageToStorage(_selectedImageFile!);
    final city = await _getCityFromCoordinates(latitude, longitude);

    if (_isLocation) {
      try {
        rocksFoundCRUD.addRockFoundWithLocation(
          user.uid,
          _RockLabel,
          imageUrl,
          latitude,
          longitude,
          city,
          DateTime.now(),
        );
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
          user.uid,
          _RockLabel,
          imageUrl,
          DateTime.now(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully saved the rock classification'),
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save rock classification'),
          ),
        );
      }
    }
  }

  void _SaveRock() async {
    var title = '';

    if (_resultStatus == _ResultStatus.notFound) {
      title = 'Fail to recognize this rock';
    } else if (_resultStatus == _ResultStatus.found) {
      title =
          "There is a $_chance proability this rock is a $_rockType $_RockLabel";
    } else {
      title = '';
    }
    var accuracyLabel = '';
    if (_resultStatus == _ResultStatus.found) {
      accuracyLabel = '${(_accuracy * 100).toStringAsFixed(2)}%';
    }

    // Confirmation
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text('Rock Classification'),
          content: Text(
            '$title with an accuracy of $accuracyLabel. Would you like to save this classification?',
          ),
          actions: <Widget>[
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text(
                    'Yes',
                    style: TextStyle(color: ForegroundColor),
                  ),
                  onPressed: () {
                    _saveClassificationWithOrWithoutLocation();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    'No',
                    style: TextStyle(color: ForegroundColor),
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
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text('Rock Classification'),
          content: Text('Failed to recognize the rock'),
          actions: <Widget>[
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text(
                    'Close',
                    style: TextStyle(color: ForegroundColor),
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
            Switch(
              value: _isLocation,
              activeColor: switchColor,
              onChanged: (value) {
                print('VALUE: $value');
                setState(() {
                  _isLocation = value;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Future<String> _getCityFromCoordinates(
      double latitude, double longitude) async {
    try {
      final List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final Placemark placemark = placemarks.first;
        return placemark.locality ?? '';
      }
    } catch (e) {
      print('Error: $e');
    }
    return '';
  }
}
