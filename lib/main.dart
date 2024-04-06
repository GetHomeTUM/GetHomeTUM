import 'package:flutter/material.dart';
import 'package:gethome/services/local_storage_service.dart';
import 'package:gethome/views/home_screen.dart';

import 'package:workmanager/workmanager.dart';
//import 'package:gethome/services/update_widget_service.dart';

// ANMERKUNG: Simulation in Xcode starten, danach Debug > Simulate Background Fetch
// um background fetch zu simulieren und die callbackDispatcher Methode auszuführen


@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {
    print("fetching...");
    print(await LocalStorageService.loadLocation('Home')); // throws error
    //use following *test* method for a simple widget update without parameters
    //UpdateWidgetService.updateBackgroundWidget();
    return Future.value(true);
  });
}

/// Main for testing the application. Insert your own key for the directions API here.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
    callbackDispatcher, // The top level function, aka callbackDispatcher
    isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );
  
  
  // starting application
  const String apiKey = '';
  runApp(const GetHomeApp(apiKey));
}
