import 'dart:convert';
import 'package:weather/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService(this.apiKey);

  // Get weather using Current Weather API by city name
  Future<Weather> getWeather(String city) async {
    final trimmedCity = city.trim();
    final response = await http.get(
      Uri.parse('$baseUrl?q=$trimmedCity&units=metric&appid=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Weather.fromJson(data, city);
    } else if (response.statusCode == 404) {
      throw Exception('City "$city" not found');
    } else {
      throw Exception('Failed to load weather: ${response.reasonPhrase}');
    }
  }
}