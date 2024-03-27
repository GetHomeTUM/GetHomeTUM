import 'package:geolocator/geolocator.dart';

class LocationService {

  ///The getCurrentLocation() method is a static asynchronous function in the LocationService class.
  ///It first checks if location services are enabled and if the necessary permissions are granted.
  ///If all checks pass, it retrieves and returns the current geographical location as a Position object using the Geolocator.getCurrentPosition() method.
  static Future<Position> getCurrentLocation() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled return an error message
      return Future.error('Location services are disabled.');
    }
    // Check location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // If permissions are granted, return the current location
    try {
      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    }
    //If facing a problem while fetching location data due to several reasons including poor GPS signal, or the device is in airplane mode.
    catch(error) {
      return Future.error(error);
    }
  }
}
