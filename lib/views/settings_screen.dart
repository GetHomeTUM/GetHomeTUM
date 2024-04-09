import 'package:flutter/material.dart';
import 'package:gethome/services/local_storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  bool? _mapSettingValue;

  @override
  void initState() {
    super.initState();

    getValues();
  }

  void getValues() async {
    _mapSettingValue = await LocalStorageService.getBoolean('map_setting');
    setState(() {
      _mapSettingValue = _mapSettingValue;
    });
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
              value: _mapSettingValue ?? false,
              onChanged: (newValue) {
                LocalStorageService.setBoolean('map_setting', newValue);
                setState(() {
                  _mapSettingValue = newValue;
                });
              },
            ),
          )
        ],
      )
    );
  }
}