import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gethome/models/get_home_location.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Enum to diffrentiate between the different types of stored valuess
enum StorageKeyTypes{
  location,
  userSetting,
}

/// Documentation: LocalStorageService
/// 
/// 4 Methods for the Location storage:
/// - setLocation(String key, GetHomeLocation location) - Future<bool>: Saves a location (overwrites if it already exists)
/// - getLocation(String key) - Future<GetHomeLocation?>: Loads a location with the given key
/// - checkLocation(String key) - Future<bool>: Checks if a location with the given key exists
/// - removeLocation(String key) - Future<void>: Removes the location with given key
///
/// 3 Methods for the boolean storage:
/// - setBoolean(String key, bool value) - Future<void>: Saves a boolean (overwrites if it already exists)
/// - getBoolean(String key) - Future<bool?>: Returns an optional boolean.
/// - removeBoolean(String key) - Future<void>: Removes a boolean for the given key.
class LocalStorageService{
  /// Instance of shared preferences
  static SharedPreferences? _storageInstance;
  
  /// Private method for checking and initializing the shared preferences instance
  static Future<void> _checkStorageInstance() async {
    /// if not already initialized, initialize the shared preferences instance
    _storageInstance ??= await SharedPreferences.getInstance();
  }

  /// Method for generating the key for a given type from the StorageKeyTypes
  static String _computeKey(String key, StorageKeyTypes type){
    String prefix = switch(type){
      StorageKeyTypes.location => "location",
      StorageKeyTypes.userSetting => "userSetting",
    };

    return "KeyType-${prefix}_${key.trim().toLowerCase()}";
  }
  
  /// Method for saving a location by the given key -> overwrites the location if the key already exists and returns true if successful
  static Future<bool> setLocation(String key, GetHomeLocation location) async {
    await _checkStorageInstance();
    
    /// Convert the GetHomeLocation object to a JSON String
    String locationJson;
    try {
      locationJson = jsonEncode(location);
    } catch (e) {
      debugPrint("Error at jsonEncode(location): $e");
      return false;
    }

    /// Use _storageInstance to save the location as the JSON String
    try {
      return await _storageInstance!.setString(_computeKey(key, StorageKeyTypes.location), locationJson);
    } catch (e) {
      debugPrint("Error at _storageInstance!.setString(key, locationJson): $e");
      return false;
    }
  }

  /// Method for loading a location by given key -> returns null if the key does not exist
  static Future<GetHomeLocation?> getLocation(String key) async {
    await _checkStorageInstance();

    /// Check if the location with the given key exists
    if(_storageInstance!.containsKey(_computeKey(key, StorageKeyTypes.location))){
      /// Load the location as a JSON String from _storageInstance
      String? locationJson = _storageInstance!.getString(_computeKey(key, StorageKeyTypes.location));
      
      /// Convert the JSON String to a GetHomeLocation object
      return GetHomeLocation.fromJson(jsonDecode(locationJson!));
    }
    
    return null;
  }

  /// Method for checking if a location with the given key exists
  static Future<bool> checkLocation(String key) async {
    await _checkStorageInstance();

    // Check if the location with the given key exists
    return _storageInstance!.containsKey(_computeKey(key, StorageKeyTypes.location));
  }

  /// Method for removing the location with given key
  static Future<void> removeLocation(String key) async {
    await _checkStorageInstance();

    // Delete the location with given key
    await _storageInstance!.remove(_computeKey(key, StorageKeyTypes.location));
  }



  /// Method for setting a boolean for the given key. -> overwrites the boolean if the key already exists and returns true if successful
  static Future<bool> setBoolean(String key, bool value) async {
    await _checkPreferencesInitialization();

    return await _preferences!.setBool(key, value);
  }

  /// Method for getting a boolean for the given key. If not present, null is returned.
  static Future<bool?> getBoolean(String key) async {
    await _checkPreferencesInitialization();

    return _preferences!.getBool(key);
  }

  /// Method for removing a boolean for the given key.
  static Future<void> removeBoolean(String key) async {
    await _checkPreferencesInitialization();

    await _preferences!.remove(key);
  }
}