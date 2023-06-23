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

  final List<Widget> _pages = [HomePage(), ProfilePage()];

  @override
  void initState() {
    startCamera();
    super.initState();
  }

  void startCamera() async {
    cameras = await availableCameras();

    cameraController =
        CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);

    await cameraController?.initialize().then((value) {
      if (!mounted) {
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
    if (cameraController != null && cameraController!.value.isInitialized) {
      final size = MediaQuery.of(context).size;
      final deviceRatio = size.width / size.height;
      final xScale = cameraController!.value.aspectRatio / deviceRatio;

      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            cameraController!.takePicture().then((XFile? file) {
              if (mounted) {
                if (file != null) {
                  print("Picture location: ${file.path}");
                }
              }
            });
          },
          child: Icon(Icons.camera),
        ),
        body: Stack(
          children: [
            Container(
              child: AspectRatio(
                aspectRatio: deviceRatio,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.diagonal3Values(xScale, 1, 1),
                  child: CameraPreview(cameraController!),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                margin: EdgeInsets.fromLTRB(50, 200, 20, 200),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 3.0,
                  ),
                ),
              ),
            ),
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

