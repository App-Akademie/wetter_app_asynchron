import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

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

Future<String> getWeatherDataAsJson() async {
  const url =
      'https://api.open-meteo.com/v1/forecast?latitude=48.783333&longitude=9.183333&current=temperature_2m,apparent_temperature,is_day,precipitation&timezone=Europe%2FBerlin&forecast_days=1';
  final response = await get(Uri.parse(url));
  return response.body;
}

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

  Future<void> setValuesFromJson() async {
    final jsonString = await getWeatherDataAsJson();
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
