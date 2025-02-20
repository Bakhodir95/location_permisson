import 'package:flutter/material.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_autocomplete_text_field/model/prediction.dart';
import 'package:location_permisson/services/changed_goole_map_service.dart';
import 'package:location_permisson/services/location_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LatLng? selected;
  late GoogleMapController mapController;
  final LatLng _najotTalim = const LatLng(41.2856806, 69.2034646);
  final _controller = TextEditingController();
  LatLng myCurrentPosition = LatLng(41.345, 69.34567);
  Set<Polyline> polylines = {};
  List<LatLng> myPositions = [];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await GooleMapService.getCurrentLocation();
      print(GooleMapService.currentLocation!.latitude!);
      myCurrentPosition = LatLng(GooleMapService.currentLocation!.latitude!,
          GooleMapService.currentLocation!.longitude!);
      setState(() {});
    });
  }

  void onCameraMove(CameraPosition position) {
    setState(() {
      myCurrentPosition = position.target;
    });
  }

  void watchMyLocation() {
    GooleMapService.getLiveLocation().listen((location) {
      print("Live location: $location");
    });
  }

  void addLocationMarker() {
    if (selected == null) {
      return;
    }

    GooleMapService.fetchPolylinePoints(
      myCurrentPosition,
      selected!,
    ).then((List<LatLng> positions) {
      polylines = {};
      polylines.add(
        Polyline(
          polylineId: PolylineId(UniqueKey().toString()),
          color: Colors.blue,
          width: 5,
          points: positions,
        ),
      );

      setState(() {});
    }).catchError((error) {
      print('Error fetching polyline points: $error');
    });
  }

  MapType currentModeType = MapType.normal;
  List<MapType> mapTypes = [
    MapType.hybrid,
    MapType.normal,
    MapType.satellite,
    MapType.terrain,
    MapType.none,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Google Map"),
        centerTitle: true,
        actions: [
          PopupMenuButton<MapType>(
            onSelected: (result) {
              currentModeType = result;
              setState(() {});
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MapType>>[
              PopupMenuItem<MapType>(
                value: mapTypes[0],
                child: const Text('Hybrid'),
              ),
              PopupMenuItem<MapType>(
                value: mapTypes[1],
                child: const Text('Normal'),
              ),
              PopupMenuItem<MapType>(
                value: mapTypes[2],
                child: const Text('Setellite'),
              ),
              PopupMenuItem<MapType>(
                value: mapTypes[3],
                child: const Text('Terrain'),
              ),
              PopupMenuItem<MapType>(
                value: mapTypes[4],
                child: const Text('None'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                GoogleMap(
                  onLongPress: (argument) {
                    selected = argument;
                    addLocationMarker();
                    setState(() {});
                  },
                  zoomControlsEnabled: false,
                  onCameraMove: onCameraMove,
                  buildingsEnabled: true,
                  onMapCreated: _onMapCreated,
                  trafficEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: _najotTalim,
                    zoom: 15.0,
                  ),
                  mapType: currentModeType,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: {
                    Marker(
                      markerId: const MarkerId("Najot Ta'lim"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _najotTalim,
                      infoWindow: const InfoWindow(
                        title: "",
                        snippet: "Xush kelibsiz Qirg'inbarot yurtga",
                      ),
                    ),
                    if (selected != null)
                      Marker(
                        onTap: () {},
                        markerId: const MarkerId("myCurrentPosition"),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue,
                        ),
                        position: selected!,
                        infoWindow: const InfoWindow(
                          title: "Najot ta'lim",
                          snippet: "Xush kelibsiz IT yurtga",
                        ),
                      ),
                  },
                  polylines: polylines,
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.white,
                    child: GooglePlacesAutoCompleteTextFormField(
                      textEditingController: _controller,
                      googleAPIKey: 'AIzaSyBmAEoDBWinPjWRfzIgOHolkni8_wSu7_o',
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter Location",
                        suffixIcon: Icon(Icons.search),
                      ),
                      isLatLngRequired: true,
                      getPlaceDetailWithLatLng: (prediction) {
                        print(
                            "Coordinates: (${prediction.lat},${prediction.lng})");
                        // addLocationMarker(prediction);
                        mapController
                            .moveCamera(
                          CameraUpdate.newLatLng(
                            LatLng(double.parse(prediction.lat!),
                                double.parse(prediction.lng!)),
                          ),
                        )
                            .then((vale) {
                          setState(() {});
                        });
                      },
                      itmClick: (prediction) {
                        _controller.text = prediction.description!;
                        _controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: prediction.description!.length),
                        );
                      },
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          mapController.animateCamera(
                            CameraUpdate.zoomOut(),
                          );
                        },
                        icon: const Icon(
                          Icons.remove_circle,
                          size: 40,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          mapController.animateCamera(
                            CameraUpdate.zoomIn(),
                          );
                        },
                        icon: const Icon(
                          Icons.add_circle,
                          size: 40,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
