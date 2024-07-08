import 'package:flutter/material.dart';
import 'package:location_permisson/services/location_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await LocationService.getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final myLocation = LocationService.currentLocation;
    print(myLocation);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          "Location Permission",
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: FlutterLogo(
          size: 250,
        ),
      ),
    );
  }
}
