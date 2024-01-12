import 'dart:convert';

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

const jsonString = """
{
    "latitude": 48.78,
    "longitude": 9.18,
    "current": {
        "time": "2024-01-12T11:45",
        "temperature_2m": -3.6,
        "apparent_temperature": -7.0,
        "is_day": 1,
        "precipitation": 12.00
    }
}
""";

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  double? feltTemperature;
  double? actualTemperature;
  double? latitude;
  double? longitude;
  bool? isDay;
  double? precipitation;

  // final double latitude = 48.783333;
  // final double longitude = 9.183333;

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
          Text(
            "Gefühlte Temperatur: $feltTemperature°",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Text(
            "Temperatur: $actualTemperature °",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Text("Niederschlag: ${precipitation?.toStringAsFixed(2)} mm"),
          const SizedBox(height: 16),
          Text("Tageszeit: ${isDay == true ? "Tag" : "Nacht"}"),
          const SizedBox(height: 16),
          Text(
            "Standort: lat: ${latitude?.toStringAsFixed(3)}, long: ${longitude?.toStringAsFixed(3)}",
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: setValuesFromJson,
            child: const Text("Vorhersage updaten"),
          )
        ],
      )),
    );
  }

  setValuesFromJson() {
    final jsonObject = jsonDecode(jsonString);

    latitude = jsonObject['latitude'];
    longitude = jsonObject['longitude'];
    feltTemperature = jsonObject['current']['apparent_temperature'];
    actualTemperature = jsonObject['current']['temperature_2m'];
    isDay = jsonObject['current']['is_day'] == 1;
    precipitation = jsonObject['current']['precipitation'];
    setState(() {});
  }
}
