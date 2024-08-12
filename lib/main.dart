//flutter
import 'package:flutter/material.dart';

//packages
import 'package:camera/camera.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';

//my imports
import 'package:deep_scan/constants.dart';
import 'package:deep_scan/screens/camera_screen.dart';
import 'package:deep_scan/screens/homepage_screen.dart';
import 'package:deep_scan/screens/scan_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //load api key from env
  await dotenv.load(fileName: ".env");

  //load cameras
  final cameras = await availableCameras();

  //load firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Pass the cameras to the app
  runApp(
    MyApp(
      cameras: cameras,
    ),
  );
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const BasePage(
              body: HomepageScreen(),
            ),
        '/scan_screen': (context) => const BasePage(
              body: ScanScreen(),
            ),
        '/camera_screen': (context) => CameraScreen(
              cameras: cameras,
            ),
      },
    );
  }
}

class BasePage extends StatelessWidget {
  const BasePage({super.key, required this.body});
  final Widget body;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Icon(Icons.menu),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.myPurple,
        foregroundColor: Colors.white,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: body,
    );
  }
}
