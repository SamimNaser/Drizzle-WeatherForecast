/// Weather Page
/// Author: Sk Samim Naser
/// Description: A weather display page with city picker, theme toggle, and animations.
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/components/weather_card.dart';
import 'package:weather/services/weather_service.dart';
import '../models/weather_model.dart';
import 'dart:async';
import 'package:intl/intl.dart';


class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String _selectedCity = 'Kolkata';
  final _weatherService = WeatherService('dde189987c77b7b75e4a3c63acc0d841');
  Weather? _weather;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  void dispose() {
    super.dispose();
  }


  String formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat.jm().format(date); // e.g., 6:45 AM
  }

  Future<void> _fetchWeather() async {
    try {
      final weather = await _weatherService.getWeather(_selectedCity);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? condition) {
    if (condition == null) return 'assets/day.json';

    switch (condition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'smog':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'drizzle':
        return 'assets/drizzels.json';
      case 'shower rain':
      case 'rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunderstorm.json';
      case 'clear':
        return 'assets/day.json';
      case 'snowfall':
      case 'snow':
        return 'assets/snowfall.json';
      default:
        return 'assets/day.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        // city search field
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: CupertinoSearchTextField(
                placeholder: "Search Location",
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    setState(() {
                      _selectedCity = value;
                      _weather = null;
                    });
                    _fetchWeather();
                  }
                },
              ),
            ),

            const SizedBox(height: 20),

            // location details 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_pin),
                Text(
                  _selectedCity.toString().toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
              ],
            ),

            // temperature details 
            _weather != null
            ? Center(
              child: Text(
                "${_weather!.temperature}°C",
                style: const TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            ),

            const SizedBox(height: 50),

            // scroll animation
            Expanded(
              child: _weather != null
              ? SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                          // temp
                          WeatherCard(
                            height: 150,
                            width: 150,
                            heading: "Humidity",
                            headingStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey.shade700
                            ),
                            text: "${_weather!.humidity}%",
                            textStyle: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            backgroundColor: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                    
                          // wind speed 
                          WeatherCard(
                            height: 150,
                            width: 150,
                            heading: "Wind Speed",
                            headingStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey.shade700
                            ),
                            text: "${_weather!.windSpeed} m/s",
                            textStyle: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            backgroundColor: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                      ],
                    ),
                
                    const SizedBox(height: 25),
                
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // maximum temp
                        WeatherCard(
                            height: 150,
                            width: 150,
                            heading: "Max Temp",
                            headingStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey.shade700
                            ),
                            text: "${_weather!.tempMax}°C",
                            textStyle: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            backgroundColor: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                
                          // minimum temp
                          WeatherCard(
                            height: 150,
                            width: 150,
                            heading: "Min Temp",
                            headingStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey.shade700
                            ),
                            text: "${_weather!.tempMin}°C",
                            textStyle: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            backgroundColor: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                      ],
                    ),
                
                    const SizedBox(height: 25),
                
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // sunrise time
                        WeatherCard(
                            height: 150,
                            width: 150,
                            heading: "Sunrise",
                            headingStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey.shade700
                            ),
                            text: formatTime(_weather!.sunrise),
                            textStyle: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            backgroundColor: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                
                          // sunset time 
                        WeatherCard(
                          height: 150,
                          width: 150,
                          heading: "Sunset",
                          headingStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey.shade700
                          ),
                          text: formatTime(_weather!.sunset),
                          textStyle: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          backgroundColor: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ],
                    )
                  ],
                ),
              )
              : const Text("Search a city to view weather..."),
            )

            // debug box 
            // _weather != null
            //     ? Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [               
            //           Text("Condition: ${_weather!.condition}"),
            //           const SizedBox(height: 4),
            //           Text("Description: ${_weather!.description}"),
            //           const SizedBox(height: 4),         
            //         ],
            //       )
            //     : const Text("Search a city to view weather..."),
          ],
        ),
      ),
    );
  }
}
