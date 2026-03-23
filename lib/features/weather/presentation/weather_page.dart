import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'weather_provider.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted) return;

    context.read<WeatherProvider>().getWeather("Istanbul");
  });
}

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Glanex Weather")),
      body: Center(
        child: provider.isLoading
            ? const CircularProgressIndicator()
            : provider.weather == null
                ? const Text("Veri yok")
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${provider.weather!.temp}°C",
                        style: const TextStyle(fontSize: 40),
                      ),
                      Text(provider.weather!.condition),
                      Text("Rüzgar: ${provider.weather!.wind} km/h"),
                      Text("Nem: ${provider.weather!.humidity}%"),
                    ],
                  ),
      ),
    );
  }
}