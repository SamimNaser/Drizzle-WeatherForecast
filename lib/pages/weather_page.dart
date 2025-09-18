import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/components/weather_card.dart';
import 'package:weather/pages/settings_page.dart';
import 'package:weather/services/weather_service.dart';
import '../models/weather_model.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String _selectedCity = '';
  WeatherService? _weatherService;
  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString('apiKey');
    if (key != null && key.isNotEmpty) {
      setState(() {
        _weatherService = WeatherService(key);
      });
      _fetchWeatherByLocation();
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Location services are disabled.');

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _fetchWeatherByLocation() async {
    if (_weatherService == null) return;
    try {
      final position = await _determinePosition();
      final weather = await _weatherService!.getWeatherByLocation(
        position.latitude,
        position.longitude,
      );
      setState(() {
        _weather = weather;
        _selectedCity = weather.city;
      });
    } catch (e) {
      print(e);
    }
  }

  bool isDayTime(Weather weather) {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    return now >= weather.sunrise && now <= weather.sunset;
  }

  String formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat.jm().format(date);
  }

  Future<void> _fetchWeather() async {
    if (_weatherService == null) return;
    try {
      final weather = await _weatherService!.getWeather(_selectedCity);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
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
        return isDay
            ? 'assets/DayBrokenClouds.json'
            : 'assets/NightBrokenClouds.json';
      case 'drizzle':
        return isDay ? 'assets/DayMist.json' : 'assets/NightMist.json';
      case 'shower rain':
      case 'rain':
        return isDay ? 'assets/DayRain.json' : 'assets/NightRain.json';
      case 'thunderstorm':
        return isDay
            ? 'assets/DayThunderstorm.json'
            : 'assets/NightThunderstorm.json';
      case 'clear':
        return isDay ? 'assets/DayClearSky.json' : 'assets/NightClearSky.json';
      case 'snowfall':
      case 'snow':
        return isDay ? 'assets/DaySnow.json' : 'assets/NightSnow.json';
      default:
        return isDay ? 'assets/DayClearSky.json' : 'assets/NightClearSky.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Always visible search bar
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 15),

                child: Row(
                  children: [

                    Expanded(
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

                    IconButton(
                      onPressed: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                        if (updated == true) {
                          _loadApiKey(); // reload API key and weather
                        }
                      },
                      icon: const Icon(Icons.settings, color: Colors.white , size: 28),
                    ),
                  ],
                ),
              ),

              // Conditional content
              _weatherService == null
                  ? const Expanded(
                      child: Center(
                        child: Text(
                          'Please enter your API key in Settings.',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Expanded(
                      child: _weather != null
                          ? Column(
                              children: [
                                // Location
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.location_pin,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    Text(
                                      _selectedCity.toUpperCase(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                // Weather animation
                                Lottie.asset(
                                  getWeatherAnimation(
                                    _weather!.condition,
                                    isDayTime(_weather!),
                                  ),
                                  height: 160,
                                  width: 160,
                                  fit: BoxFit.contain,
                                ),
                                // Temperature
                                Center(
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
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                // Weather Cards scrollable
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            // humidity
                                            WeatherCard(
                                              height: 150,
                                              width: 150,
                                              heading: "HUMIDITY",
                                              headingStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              text: "${_weather!.humidity}%",
                                              textStyle: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              icon: const Icon(
                                                Icons.water_drop,
                                                color: Colors.black,
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                15,
                                              ),
                                            ),
                                            // wind
                                            WeatherCard(
                                              height: 150,
                                              width: 150,
                                              heading: "WIND",
                                              headingStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              text: "${_weather!.windSpeed} m/s",
                                              textStyle: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              icon: const Icon(
                                                Icons.air,
                                                color: Colors.black,
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                15,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 22),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            // pressure
                                            WeatherCard(
                                              height: 150,
                                              width: 150,
                                              heading: "PRESSURE",
                                              headingStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              text: "${_weather!.pressure} hPa",
                                              textStyle: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              icon: const Icon(
                                                Icons.compress,
                                                color: Colors.black,
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                15,
                                              ),
                                            ),
                                            // feels like
                                            WeatherCard(
                                              height: 150,
                                              width: 150,
                                              heading: "FEELS LIKE",
                                              headingStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              text: "${_weather!.feelsLike}°C",
                                              textStyle: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              icon: const Icon(
                                                Icons.thermostat,
                                                color: Colors.black,
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                15,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 22),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            // max temp
                                            WeatherCard(
                                              height: 150,
                                              width: 150,
                                              heading: "HIGH",
                                              headingStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              text: "${_weather!.tempMax}°C",
                                              textStyle: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              icon: const Icon(
                                                Icons.arrow_upward,
                                                color: Colors.black,
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                15,
                                              ),
                                            ),
                                            // min temp
                                            WeatherCard(
                                              height: 150,
                                              width: 150,
                                              heading: "LOW",
                                              headingStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              text: "${_weather!.tempMin}°C",
                                              textStyle: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              icon: const Icon(
                                                Icons.arrow_downward,
                                                color: Colors.black,
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                15,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 22),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            // sunrise
                                            WeatherCard(
                                              height: 150,
                                              width: 150,
                                              heading: "SUNRISE",
                                              headingStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              text: formatTime(_weather!.sunrise),
                                              textStyle: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              icon: const Icon(
                                                Icons.wb_twilight,
                                                color: Colors.black,
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                15,
                                              ),
                                            ),
                                            // sunset
                                            WeatherCard(
                                              height: 150,
                                              width: 150,
                                              heading: "SUNSET",
                                              headingStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              text: formatTime(_weather!.sunset),
                                              textStyle: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              icon: const Icon(
                                                Icons.nights_stay,
                                                color: Colors.black,
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
