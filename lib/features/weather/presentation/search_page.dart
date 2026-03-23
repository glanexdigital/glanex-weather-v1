import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'weather_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Şehir Ara")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Şehir adı gir (örn: Istanbul)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                final city = controller.text.trim();

                if (city.isNotEmpty) {
                  context.read<WeatherProvider>().getWeatherByCity(city);
                  Navigator.pop(context);
                }
              },
              child: const Text("Ara"),
            ),
          ],
        ),
      ),
    );
  }
}