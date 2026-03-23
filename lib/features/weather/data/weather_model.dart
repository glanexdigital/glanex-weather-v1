class WeatherModel {
  final double temp;
  final String condition;
  final double wind;
  final int humidity;

  WeatherModel({
    required this.temp,
    required this.condition,
    required this.wind,
    required this.humidity,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temp: json['current']['temp_c'],
      condition: json['current']['condition']['text'],
      wind: json['current']['wind_kph'],
      humidity: json['current']['humidity'],
    );
  }
}