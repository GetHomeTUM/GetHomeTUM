import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gethome/models/get_home_location.dart';
import 'package:shared_preferences/shared_preferences.dart';


/// Documentation: LocalStorageService
/// 
/// 4 Methods for the Location storage:
/// - saveLocation(GetHomeLocation location) - Future<bool>: Saves a location (overwrites if it already exists)
/// - loadLocation(String name) - Future<GetHomeLocation?>: Loads a location with the given name
/// - checkLocation(String name) - Future<bool>: Checks if a location with the given name exists
/// - removeLocation(String name) - Future<void>: Removes the location with given name
class LocalStorageService{
  /// Instance of shared preferences
  static SharedPreferences? _preferences;
  
  /// private constructor
  LocalStorageService._();
  
  /// Private method for checking and initializing the shared preferences instance
  static Future<void> _checkPreferencesInitialization() async {
    /// if not already initialized, initialize the shared preferences instance
    _preferences ??= await SharedPreferences.getInstance();
  }

  
  /// Method for saving a location -> overwrites the location if it already exists and returns true if successful
  static Future<bool> saveLocation(GetHomeLocation location) async {
    await _checkPreferencesInitialization();
    
    /// Convert the GetHomeLocation object to a JSON String
    String locationJson;
    try {
      locationJson = jsonEncode(location);
    } catch (e) {
      debugPrint("Error at jsonEncode(location): $e");
      return false;
    }

    /// Use _preferences to save the location as the JSON String
    try {
      return await _preferences!.setString(location.getName(), locationJson).then((value) => value);
    } catch (e) {
      debugPrint("Error at _preferences!.setString(locationName, locationJson): $e");
      return false;
    }
  }


  /// Method for loading a location with name -> returns null if the name does not exist
  static Future<GetHomeLocation?> loadLocation(String name) async {
    await _checkPreferencesInitialization();

    /// Check if the location with the given name exists
    if(_preferences!.containsKey(name.trim().toLowerCase())){
      /// Load the location as a JSON String from _preferences
      String? locationJson = _preferences!.getString(name.trim().toLowerCase());
      
      /// Convert the JSON String to a GetHomeLocation object
      return GetHomeLocation.fromJson(jsonDecode(locationJson!));
    }
    
    return null;
  }


  /// Method for checking if a location with a given name exists
  static Future<bool> checkLocation(String name) async {
    await _checkPreferencesInitialization();

    /// Check if the location with the given name exists
    return _preferences!.containsKey(name.trim().toLowerCase());
  }


  /// Method for removing the location with given name
  static Future<void> removeLocation(String name) async {
    await _checkPreferencesInitialization();

    /// Delete the location with the given name
    await _preferences!.remove(name.trim().toLowerCase());
  }
}