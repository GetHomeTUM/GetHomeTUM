import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:gethome/views/list_tile_of_route.dart';
import 'package:gethome/models/get_home_route.dart';

void updateHomeWidget(var globalKey, List<GetHomeRoute>? nextRoutes) async {
  print('Updating Widget...');
  var path = await renderWidget(globalKey, nextRoutes);
  HomeWidget.setAppGroupId('group.flutter_test_widget');
  HomeWidget.saveWidgetData('filename', path);
  HomeWidget.saveWidgetData<String>('headline_title', 'hello');
  HomeWidget.saveWidgetData<String>('headline_description', 'hello test');
  HomeWidget.updateWidget(
    iOSName: 'GetHomeIos',
    androidName: 'GetHomeAndroid',
  );
}

Future<String> renderWidget(var globalKey, List<GetHomeRoute>? nextRoutes) async {
  if (globalKey.currentContext != null) {
    var path = await HomeWidget.renderFlutterWidget(
      nextRoutes != null ?
      SizedBox(
        height: 180,
        child: Column(
          children: [
            RouteListTile(route: nextRoutes[0]),
            RouteListTile(route: nextRoutes[1]),
            RouteListTile(route: nextRoutes[2]),
          ],
        )
      )
      :
      TestImage(),

      key: 'filename',
      logicalSize: globalKey.currentContext!.size!,
      pixelRatio:
        MediaQuery.of(globalKey.currentContext!).devicePixelRatio,
    ) as String;
    return path;
  }
  return 'Path not available';
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