/*
    How to implement a new UserSetting (3 changes in this file):
      1. Add a new Enum to the UserSettings List
      2. Add a new case to the parseStringToEnum method
      3. Add a new case to the getDefaultUserSettings method
      -> Check spelling for UpperCaseNames and lowercase values
*/


// --- UserSettings List: (first value is default) ---

/// UserSetting: preferred app to open directions in
enum MapsApp {
  apple,
  google,
}

/// UserSetting: unit in which the walk to the first line is displayed on the widget
enum WalkingMeasure {
  minutes,
  meters,
}

// --- UserSettings List end ---

/// This class contains all the userSettings and their possible values
/// Managing them (modify or add new) is done here
class UserSettings {
  /// Method for parsing a String(stored in the storage) to an Enum from the userSettings
  /// Example: storedString= "MapsApp.apple", returns MapsApp.apple as Enum
  static Enum parseStringToEnum(String string){
    return switch (string.split('.')[0]){
      "MapsApp" => MapsApp.values.firstWhere((e) => e.toString() == string),
      "WalkingMeasure" => WalkingMeasure.values.firstWhere((e) => e.toString() == string),
      _ => throw "Invalid userSetting: $string",
    };
  }

  // The default value for each UserSettings is definded here
  /// Method for getting the default userSettings
  static Map<String, Enum> getDefaultUserSettings(){
    return {
      'MapsApp': MapsApp.values.first,
      'WalkingMeasure': WalkingMeasure.values.first,
    };
  }
}