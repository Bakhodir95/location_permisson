import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_permisson/services/location_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController myController;
  final LatLng _center = const LatLng(39.0168, 125.7474);
  final LatLng _najotTalim = const LatLng(41.2856806, 69.2034646);

  void _onMapCreated(GoogleMapController controller) {
    myController = controller;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await LocationService.getCurrentLocation();
      setState(() {});
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
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition:
                  CameraPosition(target: _najotTalim, zoom: 15.0),
              mapType: MapType.hybrid,
              markers: {
                Marker(
                    markerId: const MarkerId("Najot Ta'lim"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _najotTalim,
                    infoWindow: const InfoWindow(
                        title: "Najot talim",
                        snippet: "Xush kelibsiz Qirg'inbarot yurtga"))
              },
            ),
          ],
        ));
  }
}
