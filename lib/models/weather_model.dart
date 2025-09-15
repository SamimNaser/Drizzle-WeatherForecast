class Weather {
  final String city;
  final int temperature;
  final int feelsLike;
  final double windSpeed;
  final String condition;
  final String description;
  final int sunrise;
  final int sunset;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final int pressure;

  Weather({
    required this.city,
    required this.temperature,
    required this.feelsLike,
    required this.windSpeed,
    required this.condition,
    required this.description,
    required this.sunrise,
    required this.sunset,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.pressure,
  });

  factory Weather.fromJson(Map<String, dynamic> json, String city) {
    final main = json['main'] as Map<String, dynamic>? ?? {};
    final weatherList = json['weather'] as List<dynamic>? ?? [];
    final weather = weatherList.isNotEmpty ? weatherList[0] as Map<String, dynamic> : {};
    final sys = json['sys'] as Map<String, dynamic>? ?? {};

    return Weather(
      city: json['name'] as String? ?? '',
      temperature: (main['temp'] as num?)?.round() ?? 0,
      feelsLike: (main['feels_like'] as num?)?.round() ?? 0,
      windSpeed: (json['wind'] != null && json['wind']['speed'] != null)
          ? (json['wind']['speed'] as num).toDouble()
          : 0.0,
      condition: weather['main'] as String? ?? '',
      description: weather['description'] as String? ?? '',
      sunrise: (sys['sunrise'] as int?) ?? 0,
      sunset: (sys['sunset'] as int?) ?? 0,
      tempMin: (main['temp_min'] as num?)?.toDouble() ?? 0.0,
      tempMax: (main['temp_max'] as num?)?.toDouble() ?? 0.0,
      humidity: (main['humidity'] as num?)?.round() ?? 0,
      pressure: (main['pressure'] as num?)?.round() ?? 0,
    );
  }
}
