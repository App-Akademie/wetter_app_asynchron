import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WeatherApp(),
    );
  }
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wetter-App"), elevation: 23),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Stadt: Stuttgart",
            style: TextStyle(color: Colors.blue, fontSize: 24),
          ),
          const SizedBox(height: 16),
          const Text(
            "Gefühlte Temperatur: -10°",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          const Text(
            "Temperatur: -4°",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          const Text("Niederschlagswahrscheinlichkeit: 15 %"),
          const SizedBox(height: 16),
          const Text("Standort: lat: 48.783, long: 9.183"),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {},
            child: const Text("Vorhersage updaten"),
          )
        ],
      )),
    );
  }
}
