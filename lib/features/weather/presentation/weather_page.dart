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
                      Container(
  width: double.infinity,
  padding: const EdgeInsets.all(24),
  margin: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    gradient: const LinearGradient(
      colors: [
        Color(0xFF4facfe),
        Color(0xFF00f2fe),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      if (provider.currentCity != null)
        Text(
          provider.currentCity!,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),

      const SizedBox(height: 10),

      Text(
        "${provider.weather!.temp}°C",
        style: const TextStyle(
          fontSize: 64,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      const SizedBox(height: 8),

      Text(
        provider.weather!.condition,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white70,
        ),
      ),

      const SizedBox(height: 20),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              const Icon(Icons.air, color: Colors.white),
              Text(
                "${provider.weather!.wind} km/h",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          Column(
            children: [
              const Icon(Icons.water_drop, color: Colors.white),
              Text(
                "${provider.weather!.humidity}%",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),

      const SizedBox(height: 20),

      if (provider.lastUpdated != null)
        Text(
          "Son güncelleme: "
          "${provider.lastUpdated!.hour.toString().padLeft(2, '0')}:"
          "${provider.lastUpdated!.minute.toString().padLeft(2, '0')}",
          style: const TextStyle(color: Colors.white70),
        ),
    ],
  ),
)
                    ],
                  ),
      ),
    );
  }
}