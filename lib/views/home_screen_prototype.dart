import 'package:flutter/material.dart';
import 'second_screen.dart';
import 'location_screen.dart';

void main() {
  runApp(GetHomeApp());
}

class GetHomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      routes: {
        '/firstScreen': (context) => MapSample(),
        '/secondScreen': (context) => SecondScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GetHome'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(
              Icons.home,
              color: Color.fromARGB(255, 0, 76, 206),
              size: 30
              ),
            title: const Text('Set Home Location'),
            onTap: () {
              Navigator.pushNamed(context, '/firstScreen');
            },
          ),
          const Divider(), // Add a divider between settings
          ListTile(
            leading: const Icon(Icons.settings,
            size: 30,
            ),
            title: Text('More Settings'),
            onTap: () {
              Navigator.pushNamed(context, '/secondScreen');
            },
          ),
          Divider(), // Add a divider between settings
          // Add more ListTile widgets for additional settings
        ],
      ),
    );
  }
}




