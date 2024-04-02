import 'package:flutter/material.dart';

/// Screen for more settings
class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More Settings'),
      ),
      
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'If we would add more settings, they would be here.',
            textAlign: TextAlign.center,
          ),
      ),
    ));
  }
}