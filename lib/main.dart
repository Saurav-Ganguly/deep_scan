import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:deep_scan/constants.dart';
import 'package:deep_scan/screens/camera_screen.dart';
import 'package:deep_scan/screens/homepage_screen.dart';
import 'package:deep_scan/screens/scan_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'firebase_options.dart';

void main() async {
  // Ensure that plugin services are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Obtain a list of available cameras
  //load env file

  await dotenv.load(fileName: ".env");

  final cameras = await availableCameras();

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

  // This widget is the root of your application.
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
