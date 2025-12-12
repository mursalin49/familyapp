import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';

class EventViewModel extends GetxController {
  final EventService _eventService = EventService();
  
  var events = <EventModel>[].obs;
  var isLoading = false.obs;
  var error = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadEvents();
  }

  /// Load all events from API
  Future<void> loadEvents() async {
    isLoading.value = true;
    error.value = null;

    try {
      final loadedEvents = await _eventService.getEvents();
      events.value = loadedEvents;
      debugPrint("✅ Loaded ${loadedEvents.length} events");
    } catch (e) {
      error.value = e.toString();
      debugPrint("❌ Error loading events: $e");
      Get.snackbar(
        "Error",
        "Failed to load events",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get events by date range
  Future<List<EventModel>> getEventsByRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    isLoading.value = true;
    error.value = null;

    try {
      final events = await _eventService.getEventsByRange(
        startDate: startDate,
        endDate: endDate,
      );
      debugPrint("✅ Loaded ${events.length} events for date range");
      return events;
    } catch (e) {
      error.value = e.toString();
      debugPrint("❌ Error loading events by range: $e");
      Get.snackbar(
        "Error",
        "Failed to load events",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Get today's events
  Future<List<EventModel>> getTodaysEvents() async {
    final today = DateTime.now();
    return await getEventsByRange(
      startDate: today,
      endDate: today,
    );
  }

  /// Create a new event
  Future<void> createEvent({
    required String title,
    required String description,
    String? location,
    required bool allDayEvent,
    required DateTime startDate,
    String? startTime,
    DateTime? endDate,
    String? endTime,
    required String visibility,
    List<String>? assignedTo,
    required bool assignedToAll,
  }) async {
    isLoading.value = true;
    error.value = null;

    try {
      final newEvent = await _eventService.createEvent(
        title: title,
        description: description,
        location: location,
        allDayEvent: allDayEvent,
        startDate: startDate,
        startTime: startTime,
        endDate: endDate,
        endTime: endTime,
        visibility: visibility,
        assignedTo: assignedTo,
        assignedToAll: assignedToAll,
      );

      debugPrint("✅ Event created successfully: ${newEvent.title}");
      
      // Reload events list to include the new event
      await loadEvents();

      Get.snackbar(
        "Success",
        "Event created successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      error.value = e.toString();
      debugPrint("❌ Error creating event: $e");
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}

