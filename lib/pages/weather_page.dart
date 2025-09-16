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

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // check local time for night/day animation
  bool isDayTime(Weather weather) {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    return now >= weather.sunrise && now <= weather.sunset;
  }

  // format sunrise/sunset time 
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
      // ignore: avoid_print
      print(e);
    }
  }

  String getWeatherAnimation(String? condition, bool isDay) {
    if (condition == null) return 'assets/Daybrokenclouds.json';

    switch (condition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'smog':
      case 'dust':
      case 'fog':
        return isDay ? 'assets/DayBrokenClouds.json' : 'assets/NightCrokenClouds.json';
      case 'drizzle':
        return isDay ? 'assets/DayMist.json' : 'assets/NightMist.json';
      case 'shower rain':
      case 'rain':
        return isDay ? 'assets/DayRain.json' : 'assets/NightRain.json';
      case 'thunderstorm':
        return isDay ? 'assets/DayThunderstorm.json' : 'assets/NightThunderstorm.json';
      case 'clear':
        return isDay ? 'assets/DayClearSky.json' : 'assets/NightClearSky.json';
      case 'snowfall':
      case 'snow':
        return isDay ? 'assets/DaySnow.json' : 'assets/NightSnow.json';
      default:
        return isDay ? 'assets/day_clear.json' : 'assets/night_clear.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          // city search field
          child: Column(
            children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: CupertinoSearchTextField(
                backgroundColor: Colors.white24,
                prefixIcon: const Icon(
                  CupertinoIcons.search,
                  color: Colors.white,
                ),
                placeholder: "Search Location",
                placeholderStyle: const TextStyle(color: Colors.white54),
                style: const TextStyle(color: Colors.white),
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

            const SizedBox(height: 10),

            // location details 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_pin, color: Colors.white ,size: 21),
                const SizedBox(width: 5),
                Text(
                  _selectedCity.toString().toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.white
                  ),
                ),
              ],
            ),

            // weather animations
            if (_weather != null)
            Lottie.asset(
              getWeatherAnimation(_weather!.condition, isDayTime(_weather!)),
              height: 160,
              width: 160,
              fit: BoxFit.contain,
            ),

            // temperature details 
            _weather != null
            ? Center(
              child: Column(
                children: [
                  Text(
                    "${_weather!.temperature}°C",
                    style: const TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  Text(
                    _weather!.condition,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.grey.shade400
                    ),
                  )
                ],
              ),
              )
            : const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            ),

            const SizedBox(height: 12),

            // scroll animation
            Expanded(
              child: _weather != null
              ? SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                          // humidity 
                          WeatherCard(
                            height: 150,
                            width: 150,
                            heading: "HUMIDITY",
                            headingStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade900
                            ),
                            text: "${_weather!.humidity}%",
                            textStyle: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            icon: const Icon(Icons.water_drop, color: Colors.black), 
                            borderRadius: BorderRadius.circular(15),
                          ),
                    
                          // wind speed 
                          WeatherCard(
                            height: 150,
                            width: 150,
                            heading: "WIND",
                            headingStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade900
                            ),
                            text: "${_weather!.windSpeed} m/s",
                            textStyle: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            icon: const Icon(Icons.air, color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                       ],
                     ),
                
                    const SizedBox(height: 22),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // pressure
                        WeatherCard(
                            height: 150,
                            width: 150,
                            heading: "PRESSURE",
                            headingStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade900
                            ),
                            text: "${_weather!.pressure} hPa",
                            textStyle: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            icon: const Icon(Icons.compress, color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                
                          // feels like
                          WeatherCard(
                            height: 150,
                            width: 150,
                            heading: "FEELS LIKE",
                            headingStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade900
                            ),
                            text: "${_weather!.feelsLike}°C",
                            textStyle: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            icon: const Icon(Icons.thermostat, color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // maximum temp
                        WeatherCard(
                            height: 150,
                            width: 150,
                            heading: "HIGH",
                            headingStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade900
                            ),
                            text: "${_weather!.tempMax}°C",
                            textStyle: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            icon:  const Icon(Icons.arrow_upward, color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                
                          // minimum temp
                          WeatherCard(
                            height: 150,
                            width: 150,
                            heading: "LOW",
                            headingStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade900
                            ),
                            text: "${_weather!.tempMin}°C",
                            textStyle: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            icon: const Icon(Icons.arrow_downward, color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                      ],
                    ),
                
                    const SizedBox(height: 22),
                
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // sunrise time
                        WeatherCard(
                            height: 150,
                            width: 150,
                            heading: "SUNRISE",
                            headingStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade900
                            ),
                            text: formatTime(_weather!.sunrise),
                            textStyle: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            icon: const Icon(Icons.wb_twilight, color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                
                        // sunset time 
                        WeatherCard(
                          height: 150,
                          width: 150,
                          heading: "SUNSET",
                          headingStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade900
                          ),
                          text: formatTime(_weather!.sunset),
                          textStyle: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          icon: const Icon(Icons.nights_stay, color: Colors.black),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ],
                    )
                  ],
                ),
              )
              : const Text("Search a city to view weather..."),
            )
          ],
        ),
      ),
    ),
    );
  }
}
