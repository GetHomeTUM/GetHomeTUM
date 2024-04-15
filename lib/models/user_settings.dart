// --- UserSettings List: (first value is default) ---

/// UserSetting: preferred app to open directions in
enum MapsApp {
  apple,
  google,
}

/// UserSetting: unit in which the walk to the first line is displayed on the widget
enum WalkingMeasure {
  minutes,
  kilometres,
}

// --- UserSettings List end ---

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


  static Map<String, Enum> getDefaultUserSettings(){
    return {
      'MapsApp': MapsApp.values.first,
      'WalkingMeasure': WalkingMeasure.values.first,
    };
  }
}