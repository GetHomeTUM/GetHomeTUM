import 'package:flutter/material.dart';
import 'package:gethome/views/home_screen.dart';

/// Main for testing the application. Insert your own key for the directions API here.
void main() {
  // starting application
  const String apiKey = 'AIzaSyAUz_PlZ-wSsnAqEHhOwRX19Q2O-gMEVZw';
  runApp(const GetHomeApp(apiKey));
}
