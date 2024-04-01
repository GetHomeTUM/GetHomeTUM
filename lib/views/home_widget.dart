import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:gethome/views/list_tile_of_route.dart';

void updateHomeWidget(String path) async {
  print('Updating Widget...');
    HomeWidget.setAppGroupId('group.flutter_test_widget');
    //HomeWidget.saveWidgetData('filename', path);
    HomeWidget.saveWidgetData<String>('headline_title', 'hello');
    HomeWidget.saveWidgetData<String>(
      'headline_description', 'hello test');
    HomeWidget.updateWidget(
      iOSName: 'GetHomeIos',
      androidName: 'GetHomeAndroid',
    );
}

class TestImage extends StatelessWidget {
  const TestImage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Text('hello world',
        style: TextStyle(fontSize: 20),),
    );
  }
}

class LineChart extends StatelessWidget {
  const LineChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: const SizedBox(
        height: 200,
        width: 200,
      ),
    );
  }
}