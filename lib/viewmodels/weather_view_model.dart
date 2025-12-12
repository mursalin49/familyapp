import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherViewModel extends GetxController {
  final WeatherService _weatherService = WeatherService();
  
  var weatherData = Rxn<OutfitSuggestionModel>();
  var isLoading = false.obs;
  var error = Rxn<String>();
  var city = 'dhaka'.obs; // Default city

  @override
  void onInit() {
    super.onInit();
    loadWeatherData();
  }

  /// Load weather and outfit suggestion data
  Future<void> loadWeatherData({String? cityName}) async {
    isLoading.value = true;
    error.value = null;

    try {
      final cityToUse = cityName ?? city.value;
      final data = await _weatherService.getOutfitSuggestion(city: cityToUse);
      weatherData.value = data;
      city.value = cityToUse;
      debugPrint("✅ Loaded weather data for ${data.weather.city}");
    } catch (e) {
      error.value = e.toString();
      debugPrint("❌ Error loading weather data: $e");
      Get.snackbar(
        "Error",
        "Failed to load weather data",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh weather data
  Future<void> refresh() async {
    await loadWeatherData();
  }
}

