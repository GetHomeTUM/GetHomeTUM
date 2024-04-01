import 'package:flutter/material.dart';
import 'package:gethome/views/home_widget.dart';
import 'package:home_widget/home_widget.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({
    super.key,
  });

  @override
  State<SecondScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<SecondScreen> {
  // New: add this GlobalKey
  final _globalKey = GlobalKey();
  // New: add this imagePath
  String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More Settings'),
      ),
      // New: add this FloatingActionButton
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          HomeWidget.setAppGroupId('group.flutter_test_widget');
          if (_globalKey.currentContext != null) {
            var path = await HomeWidget.renderFlutterWidget(
              const LineChart(),
              key: 'filename',
              logicalSize: _globalKey.currentContext!.size!,
              pixelRatio:
                  MediaQuery.of(_globalKey.currentContext!).devicePixelRatio,
            ) as String;
            setState(() {
              imagePath = path;
            });
          }
          updateHomeWidget(imagePath ?? 'No image available');
        },
        label: const Icon(Icons.widgets)
      ),
      body: Center(
        key: _globalKey,
        child: TestImage(),
      )
    );
  }
}