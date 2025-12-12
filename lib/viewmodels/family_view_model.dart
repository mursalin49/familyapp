import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/family_member_model.dart';
import '../services/family_service.dart';

class FamilyViewModel extends GetxController {
  final FamilyService _familyService = FamilyService();
  
  var familyMembers = <FamilyMemberModel>[].obs;
  var isLoading = false.obs;
  var error = Rxn<String>();
  
  @override
  void onInit() {
    super.onInit();
    loadFamilyMembers();
  }
  
  /// Load all family members from API
  Future<void> loadFamilyMembers() async {
    isLoading.value = true;
    error.value = null;
    
    try {
      final members = await _familyService.getFamilyMembers();
      familyMembers.value = members;
      debugPrint("✅ Loaded ${members.length} family members");
    } catch (e) {
      error.value = e.toString();
      debugPrint("❌ Error loading family members: $e");
      Get.snackbar(
        "Error",
        "Failed to load family members",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Get only children (for task assignment)
  List<FamilyMemberModel> get children {
    return familyMembers.where((member) => member.role == 'child').toList();
  }
  
  /// Get only parents
  List<FamilyMemberModel> get parents {
    return familyMembers.where((member) => member.role == 'parent').toList();
  }
  
  /// Refresh family members list
  Future<void> refresh() async {
    await loadFamilyMembers();
  }
  
  /// Get member by ID
  FamilyMemberModel? getMemberById(String id) {
    try {
      return familyMembers.firstWhere((member) => member.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Add child or teen profile
  Future<void> addFamilyMember({
    required String name,
    required String role,
    String? phoneNumber,
    String? email,
    String? notificationPreference,
    String? colorCode,
  }) async {
    isLoading.value = true;
    error.value = null;

    try {
      final newMember = await _familyService.addChildOrTeenProfile(
        name: name,
        role: role,
        phoneNumber: phoneNumber,
        email: email,
        notificationPreference: notificationPreference,
        colorCode: colorCode,
      );

      debugPrint("✅ Child/Teen profile created successfully: ${newMember.name}");
      
      // Reload family members list to include the new member
      await loadFamilyMembers();

      Get.snackbar(
        "Success",
        "Child/Teen profile created successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      error.value = e.toString();
      debugPrint("❌ Error creating child/teen profile: $e");
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

  /// Delete child or teen profile
  Future<void> deleteFamilyMember(String memberId) async {
    isLoading.value = true;
    error.value = null;

    try {
      await _familyService.deleteChild(memberId);

      debugPrint("✅ Family member deleted successfully: $memberId");
      
      // Reload family members list to reflect the deletion
      await loadFamilyMembers();

      Get.snackbar(
        "Success",
        "Child/Teen profile deleted successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      error.value = e.toString();
      debugPrint("❌ Error deleting family member: $e");
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

