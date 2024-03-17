import 'dart:convert';
import 'package:gethome/models/get_home_location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService{
  // instance of shared preferences
  static SharedPreferences? _preferences;
  
  LocalStorageService(){
    // Call the _initializePreferencesInstance method once the LocalStorageService is used
    _initializePreferencesInstance();
  }
  
  static Future<void> _initializePreferencesInstance() async {
    // initialize the shared preferences instance
    _preferences = await SharedPreferences.getInstance();
  }

  // TODO: (GH-13) Implement error handling
  Future<void> saveLocation(String locationId, GetHomeLocation location) async {
    // Check if _preferences Instance has been initialized
    if(_preferences == null) await _initializePreferencesInstance();
    
    // Convert the GetHomeLocation object to a JSON String
    String locationJson = jsonEncode(location);

    // Use _preferences to save the location as the JSON String
    await _preferences!.setString(locationId, locationJson);
  }


  // TODO: (GH-13) Implement error handling
  Future<GetHomeLocation> loadLocation(String locationId) async {
    // Check if _preferences Instance has been initialized
    if(_preferences == null) await _initializePreferencesInstance();

    // Load the location as a JSON String from _preferences
    String? locationJson = _preferences!.getString(locationId);

    // Convert the JSON String to a GetHomeLocation object
    GetHomeLocation location = GetHomeLocation.fromJson(jsonDecode(locationJson!));

    return location;
  }
}