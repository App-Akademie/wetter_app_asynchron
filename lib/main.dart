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

class WeatherData {
  final double feltTemperature;
  final double actualTemperature;
  final double latitude;
  final double longitude;
  final bool isDay;
  final double precipitation;

  WeatherData({
    required this.feltTemperature,
    required this.actualTemperature,
    required this.latitude,
    required this.longitude,
    required this.isDay,
    required this.precipitation,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      feltTemperature: json['current']['apparent_temperature'],
      actualTemperature: json['current']['temperature_2m'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      isDay: json['current']['is_day'] == 1,
      precipitation: json['current']['precipitation'],
    );
  }
}

Future<String> getWeatherDataAsJson() async {
  const url =
      'https://api.open-meteo.com/v1/forecast?latitude=48.783333&longitude=9.183333&current=temperature_2m,apparent_temperature,is_day,precipitation&timezone=Europe%2FBerlin&forecast_days=1';
  final response = await get(Uri.parse(url));

  // Simulate slow network
  await Future.delayed(const Duration(seconds: 2));

  return response.body;
}

Future<WeatherData> getWeatherData() async {
  final jsonString = await getWeatherDataAsJson();
  final jsonObject = jsonDecode(jsonString);

  return WeatherData.fromJson(jsonObject);
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  Future<WeatherData>? weatherData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wetter-App"), elevation: 23),
      body: Center(
          child: FutureBuilder(
        future: weatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return const Text("Fehler beim Laden der Daten");
          }
          if (snapshot.hasData == false) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Noch keine Daten geladen"),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      weatherData = getWeatherData();
                    });
                  },
                  child: const Text("Vorhersage updaten"),
                )
              ],
            );
          }
          final data = snapshot.data as WeatherData;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Stadt: Stuttgart",
                style: TextStyle(color: Colors.blue, fontSize: 24),
              ),
              const SizedBox(height: 16),
              Text(
                "Gefühlte Temperatur: ${data.feltTemperature} °",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                "Temperatur: ${data.actualTemperature} °",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text("Niederschlag: ${data.precipitation.toStringAsFixed(2)} mm"),
              const SizedBox(height: 16),
              Text("Tageszeit: ${data.isDay == true ? "Tag" : "Nacht"}"),
              const SizedBox(height: 16),
              Text(
                "Standort: lat: ${data.latitude.toStringAsFixed(3)}, long: ${data.longitude.toStringAsFixed(3)}",
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    weatherData = getWeatherData();
                  });
                },
                child: const Text("Vorhersage updaten"),
              )
            ],
          );
        },
      )),
    );
  }
}
