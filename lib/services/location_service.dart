// import 'package:location/location.dart';

// class LocationService {
//   static bool _isServiceEnabled = false;
//   static PermissionStatus permissionStatus = PermissionStatus.denied;
//   static final _location = Location();
//   static LocationData? currentLocation;

//   static Future<void> init() async {
//     await _checkService();
//     await _checkPermission();
//   }

// // joylashuvni olish xizmati yoqilganmi tekshiramiz
//   static Future<void> _checkService() async {
//     _isServiceEnabled = await _location.serviceEnabled();

//     if (!_isServiceEnabled) {
//       _isServiceEnabled = await _location.serviceEnabled();
//       return;
//     }
//   }
// // joylashuvni olish uchun ruxsat berilganmi tekshiramiz

//   static Future<void> _checkPermission() async {
//     permissionStatus = await _location.hasPermission();
//     if (permissionStatus == PermissionStatus.denied) {
//       permissionStatus = await _location.requestPermission();
//       if (permissionStatus != PermissionStatus.granted) {
//         return;
//       }
//     }
//   }

//   static Future<void> getCurrentLocation() async {
//     if (_isServiceEnabled && permissionStatus == PermissionStatus.granted) {
//       currentLocation = await _location.getLocation();
//     }
//   }
// }
