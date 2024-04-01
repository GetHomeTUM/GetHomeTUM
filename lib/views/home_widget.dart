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
      RouteWidget(nextRoutes: nextRoutes)
      :
      const TestImage(),

      key: 'filename',
      logicalSize: globalKey.currentContext!.size!,
      pixelRatio:
        MediaQuery.of(globalKey.currentContext!).devicePixelRatio,
    ) as String;
    return path;
  }
  return 'Path not available';
}

class RouteWidget extends StatelessWidget {
  final List<GetHomeRoute> nextRoutes;

  const RouteWidget({super.key, required this.nextRoutes});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 250,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 232,
              child: const Text('HOME',
              style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold),
              textAlign: TextAlign.center
                ),),
            RouteListTile(route: nextRoutes[0]),
            const SizedBox(height: 10),
            RouteListTile(route: nextRoutes[1]),
            const SizedBox(height: 10),
            RouteListTile(route: nextRoutes[2]),
          ],
        )
      );
  }}

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