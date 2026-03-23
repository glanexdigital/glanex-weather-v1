import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'weather_model.dart';

class WeatherService {
  Future<WeatherModel> fetchWeatherByCoords(double lat, double lon) async {
  final apiKey = dotenv.env['WEATHER_API_KEY'];

  final url =
      "http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$lat,$lon";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return WeatherModel.fromJson(data);
  } else {
    throw Exception("Weather API error");
  }
}
}