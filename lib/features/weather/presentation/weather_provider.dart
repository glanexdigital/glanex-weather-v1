import 'package:flutter/material.dart';
import '../data/weather_model.dart';
import '../data/weather_service.dart';
import 'dart:developer';
import '../../location/data/location_service.dart';
import '../../location/data/geocoding_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService service = WeatherService();
  final LocationService locationService = LocationService();
  final GeocodingService geocodingService = GeocodingService();

  WeatherModel? weather;
  bool isLoading = false;

  Future<void> getWeatherByLocation() async {
  isLoading = true;
  notifyListeners();

  try {
    final position = await locationService.getCurrentLocation();

    weather = await service.fetchWeatherByCoords(
      position.latitude,
      position.longitude,
    );
  } catch (e) {
    log(e.toString());
  }

  isLoading = false;
  notifyListeners();
}
}