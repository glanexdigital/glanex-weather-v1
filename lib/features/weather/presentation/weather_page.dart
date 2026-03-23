import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'weather_provider.dart';
import 'search_page.dart';

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

      context.read<WeatherProvider>().getWeatherByLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Glanex Weather"),
        actions: [
  IconButton(
    icon: const Icon(Icons.search),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SearchPage()),
      );
    },
  ),
  IconButton(
    icon: const Icon(Icons.refresh),
    onPressed: () {
      context.read<WeatherProvider>().getWeatherByLocation();
    },
  ),
],
      ),

      // 🔥 BODY EKLEDİK
      body: Center(
        child: provider.isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text("Güncelleniyor..."),
                ],
              )
            : provider.weather == null
                ? const Text("Veri yok")
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${provider.weather!.temp}°C",
                        style: const TextStyle(fontSize: 42),
                      ),
                      const SizedBox(height: 8),
                      Text(provider.weather!.condition),
                      const SizedBox(height: 8),
                      Text("Rüzgar: ${provider.weather!.wind} km/h"),
                      Text("Nem: ${provider.weather!.humidity}%"),

                      const SizedBox(height: 12),

                      // 🔥 SON GÜNCELLEME
                      if (provider.lastUpdated != null)
                        Text(
                          "Son güncelleme: "
                          "${provider.lastUpdated!.hour.toString().padLeft(2, '0')}:"
                          "${provider.lastUpdated!.minute.toString().padLeft(2, '0')}",
                          style: const TextStyle(fontSize: 12),
                        ),
                    ],
                  ),
      ),
    );
  }
}