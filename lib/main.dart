import 'package:flutter/material.dart';
import 'package:gethome/models/get_home_location.dart';
import 'package:gethome/views/home_screen.dart';

import 'dart:convert';

/// Main for testing the application. Insert your own key for the directions API here.
void main() {
  
  print(jsonEncode(GetHomeLocation(lat: 0.01, lng: 1.01).toJson()));
  // starting application
  const String apiKey = 'AIzaSyAUz_PlZ-wSsnAqEHhOwRX19Q2O-gMEVZw';
  runApp(const GetHomeApp(apiKey));
}
