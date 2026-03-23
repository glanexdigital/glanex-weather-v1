import 'package:flutter/material.dart';
import '../data/weather_model.dart';
import '../data/weather_service.dart';
import 'dart:developer';
import '../../location/data/location_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService service = WeatherService();
  final LocationService locationService = LocationService();

  WeatherModel? weather;
  bool isLoading = false;
  DateTime? lastUpdated;

  // 📍 KONUMDAN HAVA
  Future<void> getWeatherByLocation() async {
    isLoading = true;
    notifyListeners();

    try {
      final position = await locationService.getCurrentLocation();

      weather = await service.fetchWeatherByCoords(
        position.latitude,
        position.longitude,
      );

      lastUpdated = DateTime.now();
    } catch (e) {
      log(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }

  // 🔍 ŞEHİRDEN HAVA (HATA BURADAYDI 🔥)
  Future<void> getWeatherByCity(String city) async {
    isLoading = true;
    notifyListeners();

    try {
      weather = await service.fetchWeather(city);
      lastUpdated = DateTime.now();
    } catch (e) {
      log(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }
}