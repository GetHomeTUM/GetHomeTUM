import 'package:flutter/material.dart';
import 'package:gethome/models/user_settings.dart';
import 'package:gethome/services/user_settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  /// Cache for the user settings, depending on models/user_settings.dart
  final Map<String, Enum> _settingsCache = {};

  /// Variable containing User Input for API Key
  final TextEditingController _apiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Load the userSettings from the storage
    _loadUserSettings();
    // Load the API Key from the storage
    _loadApiKey();
  }

  /// Method to load all userSettings from the storage
  void _loadUserSettings() {
    for (String userSetting in UserSettings.getDefaultUserSettings().keys) {
      UserSettingsService.getUserSetting(userSetting).then((value) => {
            setState(() {
              _settingsCache[userSetting] = value;
            }),
          });
    }
  }

  /// Method to load the API Key from the storage

  void _loadApiKey() async {
    String currentApiKey = await UserSettingsService.getAPIKey();
    if (mounted) {
      setState(() {
        _apiKeyController.text = currentApiKey;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(
          children: <Widget>[
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Use Apple Maps as preferred map provider'),
              trailing: Switch(
                activeColor: Colors.blue,
                value: _settingsCache['MapsApp'] == MapsApp.apple,
                onChanged: (newValue) {
                  // Update the chache
                  setState(() {
                    _settingsCache['MapsApp'] =
                        newValue ? MapsApp.apple : MapsApp.google;
                  });

                  // Update the storage
                  UserSettingsService.setUserSetting(
                      'MapsApp', _settingsCache['MapsApp']!);
                },
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                  'Display walking distance in minutes instead of meters'),
              trailing: Switch(
                activeColor: Colors.blue,
                value:
                    _settingsCache['WalkingMeasure'] == WalkingMeasure.minutes,
                onChanged: (newValue) {
                  // Update the chache
                  setState(() {
                    _settingsCache['WalkingMeasure'] = newValue
                        ? WalkingMeasure.minutes
                        : WalkingMeasure.meters;
                  });

                  // Update the storage
                  UserSettingsService.setUserSetting(
                      'WalkingMeasure',
                      newValue
                          ? WalkingMeasure.minutes
                          : WalkingMeasure.meters);
                },
              ),
            ),
            const Divider(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _apiKeyController,
                decoration: const InputDecoration(
                  labelText: 'API Key',
                  hintText: 'Enter your API Key',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (newValue) {
                  UserSettingsService.setAPIKey(newValue);
                  print("New Value: " + newValue);
                  _apiKeyController.text = newValue;
                },
              ),
            ),
          ],
        ));
  }
}
