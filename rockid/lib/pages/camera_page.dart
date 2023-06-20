import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();

}
class _CameraScreenState extends State<CameraScreen> {
  late List<CameraDescription> cameras;
  CameraController? cameraController;

  @override
  void initState() {
    startCamera();
    super.initState();
  }

  void startCamera() async {
    cameras = await availableCameras();

    cameraController = CameraController(
      cameras[0], 
      ResolutionPreset.low,
      enableAudio: false
      );

    await cameraController?.initialize().then((value) {
      if(!mounted) {
        return;
      }
      setState(() {});
    }).catchError((e) {
      print('Error initializing camera: $e');
  
    });
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(cameraController != null && cameraController!.value.isInitialized) {
      print("camera initialized!");
      return Scaffold(
        body: Stack(
          children: [
            CameraPreview(cameraController!),
          ],
        )

      );
    } else {
      return const SizedBox();
    }
  }
}