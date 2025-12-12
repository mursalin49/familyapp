class WeatherModel {
  final String city;
  final String country;
  final int temperature;
  final int feelsLike;
  final String skyCondition;
  final String description;
  final int humidity;
  final double windSpeed;

  WeatherModel({
    required this.city,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.skyCondition,
    required this.description,
    required this.humidity,
    required this.windSpeed,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    // Helper function to safely convert to int
    int toInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    }

    // Helper function to safely convert to double
    double toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    return WeatherModel(
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      temperature: toInt(json['temperature']),
      feelsLike: toInt(json['feelsLike']),
      skyCondition: json['skyCondition'] as String? ?? '',
      description: json['description'] as String? ?? '',
      humidity: toInt(json['humidity']),
      windSpeed: toDouble(json['windSpeed']),
    );
  }
}

class OutfitModel {
  final int temperature;
  final String skyCondition;
  final List<String> layers;
  final List<String> accessories;
  final List<String> footwear;
  final List<String> additionalTips;
  final String summary;

  OutfitModel({
    required this.temperature,
    required this.skyCondition,
    required this.layers,
    required this.accessories,
    required this.footwear,
    required this.additionalTips,
    required this.summary,
  });

  factory OutfitModel.fromJson(Map<String, dynamic> json) {
    return OutfitModel(
      temperature: json['temperature'] as int? ?? 0,
      skyCondition: json['skyCondition'] as String? ?? '',
      layers: (json['layers'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      accessories: (json['accessories'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      footwear: (json['footwear'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      additionalTips: (json['additionalTips'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      summary: json['summary'] as String? ?? '',
    );
  }
}

class OutfitSuggestionModel {
  final WeatherModel weather;
  final OutfitModel outfit;

  OutfitSuggestionModel({
    required this.weather,
    required this.outfit,
  });

  factory OutfitSuggestionModel.fromJson(Map<String, dynamic> json) {
    return OutfitSuggestionModel(
      weather: WeatherModel.fromJson(json['weather'] as Map<String, dynamic>),
      outfit: OutfitModel.fromJson(json['outfit'] as Map<String, dynamic>),
    );
  }
}

