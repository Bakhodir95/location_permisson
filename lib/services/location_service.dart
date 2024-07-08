import 'package:location/location.dart';

class LocationService {
  static bool isServiceEnabled = false;
  static PermissionStatus permissionStatus = PermissionStatus.denied;
  static final _location = Location();
  static LocationData? currentLocation;

// joylashuvni olish xizmati yoqilganmi tekshiramiz
  static void checkService() async {
    bool isServiceEnabled = await _location.serviceEnabled();

    if (!isServiceEnabled) {
      isServiceEnabled = await _location.serviceEnabled();
      return;
    }
  }
// joylashuvni olish uchun ruxsat berilganmi tekshiramiz

  static void checkPermission() async {
    permissionStatus = await _location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await _location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    }
  }

  static void getCurrentLocation() async {
    if (isServiceEnabled && permissionStatus == PermissionStatus.granted) {
      currentLocation = await _location.getLocation();
    }
  }
}
