import 'package:flutter/material.dart';
import 'package:location_permisson/screens/home_screen.dart';
import 'package:permission_handler/permission_handler.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding
      .ensureInitialized(); // widgetlar tayyorligiga ishonch hosil qiladi

  final cameraPermission = await Permission.camera.status;
  print(cameraPermission);

  if (cameraPermission != PermissionStatus.granted) {
    await Permission.camera.request();
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
