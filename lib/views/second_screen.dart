import 'package:flutter/material.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({
    super.key,
  });

  @override
  State<SecondScreen> createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More Settings'),
      ),
      // New: add this FloatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: () => print('empty block.'),
        child: const Icon(Icons.widgets)
      ),
      body: Center(
        
      )
    );
  }
}