import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/message_model.dart';
import '../services/message_service.dart';

class MessageViewModel extends GetxController {
  final MessageService _messageService = MessageService();
  
  var isLoading = false.obs;
  var error = Rxn<String>();

  /// Send a message to a family member
  Future<SendMessageResponse> sendMessage({
    required String recipientId,
    required String recipientType,
    required String subject,
    required String message,
    required String deliveryMethod,
  }) async {
    isLoading.value = true;
    error.value = null;

    try {
      final response = await _messageService.sendMessage(
        recipientId: recipientId,
        recipientType: recipientType,
        subject: subject,
        message: message,
        deliveryMethod: deliveryMethod,
      );

      debugPrint("✅ Message sent successfully: ${response.message.subject}");
      
      Get.snackbar(
        "Success",
        "Message sent successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return response;
    } catch (e) {
      error.value = e.toString();
      debugPrint("❌ Error sending message: $e");
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

