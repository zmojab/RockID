import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class RockID extends StatefulWidget {
  @override
  _RockIDState createState() => _RockIDState();
}

class _RockIDState extends State<RockID> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  late List<CameraDescription> _availableCameras;
  late String _modelPath;
  late Interpreter _interpreter;
  late File _pickedImage;
  bool _isImageLoaded = false;
  List<dynamic> _outputClasses = [];

  @override
  void initState() {
    super.initState();
    _loadModel().then((value) {
      _initCamera();
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _loadModel() async {
    _modelPath = 'lib/assets/78%.tflite'; // Replace with your model path
    try {
      _interpreter = await Interpreter.fromAsset(_modelPath);
    } catch (e) {
      print('Failed to load model: $e');
    }
  }

  Future<void> _initCamera() async {
    _availableCameras = await availableCameras();
    if (_availableCameras.isNotEmpty) {
      _cameraController =
          CameraController(_availableCameras[0], ResolutionPreset.medium);
      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  void _captureImage() async {
    if (_isCameraInitialized) {
      try {
        final image = await _cameraController!.takePicture();
        setState(() {
          _pickedImage = File(image.path);
          _isImageLoaded = true;
        });
        _classifyImage(_pickedImage);
      } catch (e) {
        print('Failed to capture image: $e');
      }
    }
  }

  void _pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _pickedImage = File(image.path);
          _isImageLoaded = true;
        });
        _classifyImage(_pickedImage);
      }
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void _classifyImage(File imageFile) async {
    try {
      final inputImage = imageFile.readAsBytesSync();
      final inputs = <String, dynamic>{};
      inputs['input'] = inputImage;

      final outputs = <String, dynamic>{};
      outputs['output'] = List.filled(1 * 1000, 0.0);

      _interpreter.run(inputs, outputs);

      setState(() {
        _outputClasses = outputs['output'];
      });
    } catch (e) {
      print('Failed to classify image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rock Identification'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isImageLoaded ? Image.file(_pickedImage) : Container(),
          ),
          ElevatedButton(
            onPressed: _captureImage,
            child: const Text('Capture Image'),
          ),
          ElevatedButton(
            onPressed: _pickImageFromGallery,
            child: const Text('Pick Image from Gallery'),
          ),
          const Text(
            'Results:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _outputClasses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${_outputClasses[index]}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
