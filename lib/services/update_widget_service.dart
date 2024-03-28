import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

class UpdateWidgetService {
  Future<void> updateHomeWidget() async {
    try {
      // Fetch the gethomeroutes from the API service
      await HomeWidget.renderFlutterWidget(const Text("Hello"), key: "routes");
    } catch (e) {
      // Handle any errors that occur during the update process
      print('Error updating home widget: $e');
    }
  }
}
