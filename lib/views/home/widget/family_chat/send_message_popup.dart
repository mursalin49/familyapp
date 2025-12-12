import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../viewmodels/family_view_model.dart';
import '../../../../viewmodels/message_view_model.dart';
import '../../../../models/family_member_model.dart';
import '../../../widgets/custom_dropdown.dart';

class SendMessagePopup extends StatefulWidget {
  const SendMessagePopup({super.key});

  @override
  State<SendMessagePopup> createState() => _SendMessagePopupState();
}

class _SendMessagePopupState extends State<SendMessagePopup> {
  String? selectedFamilyId;
  String? selectedDelivery = "In-app notification"; // Default to In-app notification
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  bool _isSubmitting = false;

  late final FamilyViewModel _familyViewModel;
  late final MessageViewModel _messageViewModel;

  final List<String> deliveryMethods = [
    "In-app notification",
    "Text message (SMS)",
    "Email",
    "All"
  ];

  @override
  void initState() {
    super.initState();
    // Get or create ViewModels
    try {
      _familyViewModel = Get.find<FamilyViewModel>();
    } catch (e) {
      _familyViewModel = Get.put(FamilyViewModel());
    }
    
    try {
      _messageViewModel = Get.find<MessageViewModel>();
    } catch (e) {
      _messageViewModel = Get.put(MessageViewModel());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Send Family Message",
                    style: TextStyle(
                      fontFamily: 'Prompt_regular',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  )
                ],
              ),
              SizedBox(height: 16.h),

              // Send To Dropdown
              Text(
                "Send to:",
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 5.h),
              Obx(() {
                final members = _familyViewModel.familyMembers;
                if (members.isEmpty) {
                  return Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "No family members available",
                      style: TextStyle(
                        fontFamily: 'Prompt_regular',
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  );
                }
                
                final memberItems = members.map((member) {
                  String roleDisplay = member.role == 'child' 
                      ? (member.isTeen ? 'Teen' : 'Child')
                      : member.role == 'parent' 
                          ? 'Parent'
                          : member.role;
                  return "${member.name} ($roleDisplay)";
                }).toList();
                
                FamilyMemberModel? selectedMember;
                try {
                  selectedMember = members.firstWhere(
                    (m) => m.id == selectedFamilyId
                  );
                } catch (e) {
                  selectedMember = null;
                }
                final selectedDisplay = selectedMember != null
                    ? "${selectedMember.name} (${selectedMember.role == 'child' ? (selectedMember.isTeen ? 'Teen' : 'Child') : selectedMember.role == 'parent' ? 'Parent' : selectedMember.role})"
                    : null;
                
                return CustomDropdown<String>(
                  items: memberItems.toDropdownItems((item) => item),
                  value: selectedDisplay,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      final member = members.firstWhere(
                        (m) {
                          String roleDisplay = m.role == 'child' 
                              ? (m.isTeen ? 'Teen' : 'Child')
                              : m.role == 'parent' 
                                  ? 'Parent'
                                  : m.role;
                          return "${m.name} ($roleDisplay)" == newValue;
                        }
                      );
                      setState(() {
                        selectedFamilyId = member.id;
                      });
                    }
                  },
                  hintText: "Choose family member",
                );
              }),
              SizedBox(height: 16.h),

              // Subject
              Text(
                "Subject:",
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 5.h),
              TextField(
                controller: subjectController,
                decoration: InputDecoration(
                  hintText: "e.g. Buy the grocery",
                  hintStyle: TextStyle(
                    fontFamily: 'Prompt_regular',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Message
              Text(
                "Message:",
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 5.h),
              TextField(
                controller: messageController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText:
                  "Make sure to buy the grocery on time. There is no grocery in home right now.",
                  hintStyle: TextStyle(
                    fontFamily: 'Prompt_regular',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Delivery Method Dropdown
              Text(
                "Delivery Method:",
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 5.h),
              CustomDropdown<String>(
                items: deliveryMethods.toDropdownItems((item) => item),
                value: selectedDelivery,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDelivery = newValue;
                  });
                },
                hintText: "In-app notification",
              ),

              SizedBox(height: 24.h),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _handleSendMessage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: _isSubmitting
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : SvgPicture.asset("assets/icons/shareIcon.svg"),
                      label: Text(
                        _isSubmitting ? "Sending..." : "Send Message",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Handle send message button press
  Future<void> _handleSendMessage() async {
    // Validation
    if (selectedFamilyId == null) {
      Get.snackbar(
        "Error",
        "Please select a family member",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (subjectController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a subject",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (messageController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a message",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedDelivery == null) {
      Get.snackbar(
        "Error",
        "Please select a delivery method",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Get selected family member
      final member = _familyViewModel.getMemberById(selectedFamilyId!);
      if (member == null) {
        throw Exception("Selected family member not found");
      }

      // Determine recipient type
      String recipientType = "Child";
      if (member.role == 'child') {
        recipientType = member.isTeen ? "Teen" : "Child";
      } else if (member.role == 'parent') {
        recipientType = "Parent";
      }

      // Map delivery method from UI to API
      String deliveryMethod = "in-app";
      switch (selectedDelivery) {
        case "In-app notification":
          deliveryMethod = "in-app";
          break;
        case "Text message (SMS)":
          deliveryMethod = "sms";
          break;
        case "Email":
          deliveryMethod = "email";
          break;
        case "All":
          deliveryMethod = "all";
          break;
        default:
          deliveryMethod = "in-app";
      }

      // Send message
      await _messageViewModel.sendMessage(
        recipientId: selectedFamilyId!,
        recipientType: recipientType,
        subject: subjectController.text.trim(),
        message: messageController.text.trim(),
        deliveryMethod: deliveryMethod,
      );

      // Close modal on success
      if (mounted) {
        Navigator.of(context).pop();
        // Clear form
        subjectController.clear();
        messageController.clear();
        setState(() {
          selectedFamilyId = null;
          selectedDelivery = null;
        });
      }
    } catch (e) {
      // Error is already handled in the ViewModel
      setState(() {
        _isSubmitting = false;
      });
    }
  }
}
