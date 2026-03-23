import 'package:flutter/material.dart';
import '../data/weather_model.dart';
import '../data/weather_service.dart';
import 'dart:developer';

class WeatherProvider extends ChangeNotifier {
  final WeatherService service = WeatherService();

  WeatherModel? weather;
  bool isLoading = false;

  Future<void> getWeather(String city) async {
    isLoading = true;
    notifyListeners();

    try {
      weather = await service.fetchWeather(city);
    } catch (e) {
      log(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }
}