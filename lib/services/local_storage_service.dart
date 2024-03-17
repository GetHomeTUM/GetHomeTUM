import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gethome/models/get_home_location.dart';
import 'package:shared_preferences/shared_preferences.dart';


/*
  Documentation: LocalStorageService
  
  4 Methods for the Location storage:
  - saveLocation(String locationId, GetHomeLocation location) - Future<void>: Saves a location with a given id (overwrite if exists already) and returns true if successful
  - loadLocation(String locationId) - Future<GetHomeLocation?>: Loads a location with a given id (null if it does not exist)
  - checkLocation(String locationId) - Future<bool>: Checks if a location with a given id exists
  - removeLocation(String locationId) - Future<void>: Removes a location with a given id
*/
class LocalStorageService{
  // Instance of shared preferences
  static SharedPreferences? _preferences;
  
  // Constructor
  LocalStorageService(){
    // Call the _initializePreferencesInstance method once the LocalStorageService is used
    _initializePreferencesInstance();
  }
  
  static Future<void> _initializePreferencesInstance() async {
    // initialize the shared preferences instance
    _preferences = await SharedPreferences.getInstance();
  }

  
  // Method for saving a location with a given id -> overwrites the location if it already exists and returns true if successful
  Future<bool> saveLocation(GetHomeLocation location) async {


    // Check if _preferences Instance has been initialized
    if(_preferences == null) await _initializePreferencesInstance();
    
    // Convert the GetHomeLocation object to a JSON String
    String locationJson;
    try {
      locationJson = jsonEncode(location);
    } catch (e) {
      debugPrint("Error at jsonEncode(location): $e");
      return false;
    }

    // Use _preferences to save the location as the JSON String
    try {
      return await _preferences!.setString(location.getId(), locationJson).then((value) => value);
    } catch (e) {
      debugPrint("Error at _preferences!.setString(locationId, locationJson): $e");
      return false;
    }
  }


  // Method for loading a location with a given id -> returns null if locationId does not exist
  Future<GetHomeLocation?> loadLocation(String locationId) async {
    // Check if _preferences Instance has been initialized
    if(_preferences == null) await _initializePreferencesInstance();

    // Check if the location with the given id exists
    if(_preferences!.containsKey(locationId)){
      // Load the location as a JSON String from _preferences
      String? locationJson = _preferences!.getString(locationId);
      
      // Convert the JSON String to a GetHomeLocation object
      return GetHomeLocation.fromJson(jsonDecode(locationJson!));
    }
    
    return null;
  }


  // Method for checking if a location with a given id exists
  Future<bool> checkLocation(String locationId) async {
    // Check if _preferences Instance has been initialized
    if(_preferences == null) await _initializePreferencesInstance();

    // Check if the location with the given id exists
    return _preferences!.containsKey(locationId);
  }


  // Method for removing a location with a given id
  Future<void> removeLocation(String locationId) async {
    // Check if _preferences Instance has been initialized
    if(_preferences == null) await _initializePreferencesInstance();

    // Delete the location with the given id
    await _preferences!.remove(locationId);
  }
}