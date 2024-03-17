import 'package:gethome/models/get_home_location.dart';

// TODO: (GH-13) add Documentation
class LocalStorageService{
  
  // TODO: (GH-13) Implement error handling
  Future<void> saveLocation(String locationId, GetHomeLocation location) async {
  }


  // TODO: (GH-13) Implement error handling
  Future<GetHomeLocation?> loadLocation(String locationId) async {
    return null;
  }

  // Method for checking if a location with a given id exists
  Future<bool> checkLocation(String locationId) async {
    return true;
  }
}