import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:gethome/views/list_tile_of_route.dart';

void updateHomeWidget(Scaffold tile) async {
  var path = await HomeWidget.renderFlutterWidget(
    tile,
    key: 'testWidget',
    logicalSize: const Size(400, 400),
    );
  HomeWidget.saveWidgetData('testId', path);
  HomeWidget.updateWidget(
    iOSName: 'GetHomeIos',
    androidName: 'GetHomeAndroid',
  );
}