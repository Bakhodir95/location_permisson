import 'package:flutter/material.dart';
import 'package:location_permisson/screens/home_screen.dart';
import 'package:permission_handler/permission_handler.dart';

void main(List<String> args) async {
//? https://pub.dev/packages/permission_handler  Access to other Permissions (link)
  WidgetsFlutterBinding
      .ensureInitialized(); // widgetlar tayyorligiga ishonch hosil qiladi

  PermissionStatus cameraPermission = await Permission.camera.status;
  PermissionStatus locationPermission = await Permission.location.status;

  print(cameraPermission);
  print(locationPermission);

  // if (cameraPermission != PermissionStatus.granted) {
  //   await Permission.camera.request();
  // }
  // if (locationPermission != PermissionStatus.granted) {
  //   await Permission.location.request();
  // }
  if (!(await Permission.camera.request().isGranted) ||
      !(await Permission.camera.request().isGranted)) {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.camera,
    ].request();

    print(statuses);
  }
  runApp(PermissonApp());
}

class PermissonApp extends StatelessWidget {
  const PermissonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
