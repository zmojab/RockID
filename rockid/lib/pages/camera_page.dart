import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:rockid/pages/Home_page.dart';
import 'package:rockid/pages/profile_page.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();

}
class _CameraScreenState extends State<CameraScreen> {
  late List<CameraDescription> cameras;
  CameraController? cameraController;

  int _selectedIndex = 0;
  final List<Widget> _pages = [HomePage(), ProfilePage()];

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
            GestureDetector(
              onTap: () {
                cameraController!.takePicture().then((XFile? file) {
                  if(mounted) {
                    if(file != null) {
                      print("Picture saved to ${file.path}");
                    }
                  }
                });
              },
              child: button(Icons.camera_alt_outlined, Alignment.bottomCenter), 
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
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
    } else {
      return const SizedBox();
    }
  }
}

Widget button(IconData icon, Alignment alignment) {
  return Align(
    alignment: alignment,
    child: Container(
      margin: const EdgeInsets.only(
          left: 20,
          bottom: 20,
      ),
      height: 50,
      width: 50,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          color: Colors.black54,
        ),
      ),
    ),
  );
}