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

bool isHourly = true;

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

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.weather == null
              ? const Center(child: Text("Veri yok"))
              : Column(
                  children: [

                    // HEADER
Transform.translate(
  offset: const Offset(0, -30), // 🔥 yukarı kaydırır
  child: Container(
    margin: const EdgeInsets.symmetric(horizontal: 16), // ❗ negatif yok
    width: double.infinity,
    padding: const EdgeInsets.only(top: 40, bottom: 30),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      gradient: LinearGradient(
        colors: [
          Color(0xFF4facfe),
          Color(0xFF00f2fe),
        ],
      ),
    ),
    child: Column(
      children: [
        Text(
          provider.currentCity ?? "",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "${provider.weather!.temp}°C",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          provider.weather!.condition,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    ),
  ),
),
                    
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [

                            const SizedBox(height: 16),

                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildInfoItem(Icons.air, "Rüzgar", "${provider.weather!.wind} km/h"),
                                  _buildInfoItem(Icons.water_drop, "Nem", "${provider.weather!.humidity}%"),
                                  _buildInfoItem(Icons.umbrella, "Yağış", "%20"),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade200,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.warning, color: Colors.orange),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text("2 saat sonra yağmur bekleniyor"),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [

      _buildToggleButton("Saatlik", isHourly, () {
        setState(() => isHourly = true);
      }),

      const SizedBox(width: 10),

      _buildToggleButton("Günlük", !isHourly, () {
        setState(() => isHourly = false);
      }),

    ],
  ),
),
                            const SizedBox(height: 16),

                            SizedBox(
  height: 100,
  child: isHourly
      ? ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: const [
            HourItem(time: "12:00", temp: "21°"),
            HourItem(time: "13:00", temp: "22°"),
            HourItem(time: "14:00", temp: "20°"),
            HourItem(time: "15:00", temp: "19°"),
          ],
        )
      : ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: const [
            HourItem(time: "Pzt", temp: "22°"),
            HourItem(time: "Sal", temp: "19°"),
            HourItem(time: "Çar", temp: "21°"),
          ],
        ),
),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
      bottomNavigationBar: BottomNavigationBar(
  currentIndex: 0,
  selectedItemColor: Colors.blue,
  unselectedItemColor: Colors.grey,
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.cloud),
      label: "Hava",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.star),
      label: "Favoriler",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.radar),
      label: "Radar",
    ),
  ],
),          
    );
  }
}
Widget _buildInfoItem(IconData icon, String title, String value) {
  return Column(
    children: [
      Icon(icon, color: Colors.blue),
      const SizedBox(height: 5),
      Text(title),
      Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
    ],
  );
}

class HourItem extends StatelessWidget {
  final String time;
  final String temp;

  const HourItem({
    super.key,
    required this.time,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 8,
    ),
  ],
),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(time),
          const SizedBox(height: 5),
          Text(temp, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

Widget _buildToggleButton(String text, bool isActive, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}