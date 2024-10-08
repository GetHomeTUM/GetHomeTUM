import 'package:flutter/material.dart';
import 'package:gethome/views/next_routes.dart';
import 'settings_screen.dart';
import 'location_screen.dart';

/// Class for the logic of the home screen. Provides the links for the other app pages.
class GetHomeApp extends StatelessWidget {

  const GetHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),

      routes: {
        '/firstScreen': (context) => const MapScreen(),
        '/secondScreen': (context) => const SettingsScreen(),
        '/thirdScreen': (context) => const RoutesScreen(),
      },
      
    );
  }
}

/// Class for the design of the home screen. Creates a scrollable list on the screen where you can tap on to 
/// get to the desired page.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('GetHome'),
        automaticallyImplyLeading: false,
      ),

      body: ListView(
        // list of widgets that are displayed as a scrollable list in the given order
        children: <Widget>[
          // ListTile that represents one simple page. By tapping on it, you get directed to this page.
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
            title: const Text('Settings'),
            onTap: () {
              Navigator.pushNamed(context, '/secondScreen');
            },
          ),
          const Divider(), // Add a divider between settings
          ListTile(
            leading: const Icon(
              Icons.train,
              color: Colors.grey,
              size: 30
              ),
            title: const Text('Next connections'),
            onTap: () {
              Navigator.pushNamed(context, '/thirdScreen');
            },
          ),
          const Divider(),
          // Add more ListTile widgets for additional pages
        ],
      ),

    );
  }
}




