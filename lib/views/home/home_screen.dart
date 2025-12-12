import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mom_app/healpers/route.dart';
import 'package:mom_app/views/home/widget/dashboard/family_dishwasher_Card.dart';
import 'package:mom_app/views/home/widget/dashboard/voice_note_dialog.dart';
import 'package:mom_app/views/home/widget/family_chat/family_member_card.dart';
import 'package:mom_app/views/home/widget/family_chat/recent_chat_card.dart';
import 'package:mom_app/views/home/widget/family_chat/send_message_popup.dart';
import 'package:mom_app/views/home/widget/passwords/add_new_password_dialog.dart';
import 'package:mom_app/views/home/widget/passwords/password_saved_card.dart';
import 'package:mom_app/views/home/widget/passwords/remove_all_password_dialog.dart';
import 'package:mom_app/views/home/widget/passwords/search_field.dart';
import '../../utils/app_colors.dart';
import '../../models/task_model.dart';
import '../widgets/task_item_widget.dart';
import '../widgets/create_task_modal.dart';
import 'package:get/get.dart';
import '../../viewmodels/auth_view_mode.dart';
import '../../viewmodels/task_view_model.dart';
import '../../viewmodels/event_view_model.dart';
import '../../viewmodels/weather_view_model.dart';

import '../widgets/app_header.dart';

class TabControllerX extends GetxController {
  var selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TabControllerX controller = Get.put(TabControllerX());
  final List<String> tabs = ["Dashboard", "Family Chat", "Passwords"];
  final AuthViewModel authViewModel = Get.find<AuthViewModel>();
  final TaskViewModel taskViewModel = Get.put(TaskViewModel());
  final EventViewModel eventViewModel = Get.put(EventViewModel());

  @override
  void initState() {
    super.initState();
    // Load user info if not already loaded
    if (authViewModel.currentUser.value?.familyname == null) {
      authViewModel.getUserInfo();
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good morning";
    } else if (hour < 17) {
      return "Good afternoon";
    } else {
      return "Good evening";
    }
  }

  int _getTasksDueToday() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    
    return taskViewModel.tasks.where((task) {
      if (task.dueDate == null) return false;
      final taskDateOnly = DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
      return taskDateOnly.isAtSameMomentAs(todayDate) && task.status != 'completed';
    }).length;
  }

  int _getEventsToday() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    
    return eventViewModel.events.where((event) {
      final eventDateOnly = DateTime(event.startDate.year, event.startDate.month, event.startDate.day);
      return eventDateOnly.isAtSameMomentAs(todayDate);
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppHeader(),

          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.047),
                Obx(() {
                  final familyName = authViewModel.currentUser.value?.familyname ?? "Family";
                  return Text(
                    "${_getGreeting()}, $familyName!",
                    style: TextStyle(
                      fontFamily: 'Prompt_regular',
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  );
                }),
                SizedBox(height: 4.h),
                SvgPicture.asset(
                  "assets/icons/clapIcon.svg",
                  width: 24.w,
                  height: 24.h,
                ),
                SizedBox(height: 4.h),
                Text(
                  "Here’s what’s happening today",
                  style: TextStyle(
                    fontFamily: 'Prompt_regular',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w300,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Obx(() => Column(
                          children: [
                            Text(
                              "${_getTasksDueToday()}",
                              style: TextStyle(
                                fontFamily: 'Prompt_regular',
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.buttonColor,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              "Tasks Due",
                              style: TextStyle(
                                fontFamily: 'Prompt_regular',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textColor,
                              ),
                            ),
                          ],
                        )),
                        SizedBox(width: 16.w),
                        Obx(() => Column(
                          children: [
                            Text(
                              "${_getEventsToday()}",
                              style: TextStyle(
                                fontFamily: 'Prompt_regular',
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.buttonColor,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              "Events Today",
                              style: TextStyle(
                                fontFamily: 'Prompt_regular',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textColor,
                              ),
                            ),
                          ],
                        ))
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: (){
                            Get.dialog(VoiceNoteDialog());
                          },
                          child: SvgPicture.asset("assets/icons/voiceTextIcon.svg", width: 30.w, height: 30.h),
                        ),
                        SizedBox(width: 8.w),
                        InkWell(
                          onTap: (){},
                          child: SvgPicture.asset("assets/icons/bookIcon.svg", width: 30.w, height: 30.h),
                        ),
                        SizedBox(width: 8.w),
                        InkWell(
                          onTap: (){},
                          child: SvgPicture.asset("assets/icons/aiIcon.svg", width: 30.w, height: 30.h),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 16.h),

                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFFEDF1F7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFF757575).withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(tabs.length, (index) {
                        final bool isSelected =
                            controller.selectedIndex.value == index;
                        return GestureDetector(
                          onTap: () => controller.changeTab(index),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : Color(0xFFEDF1F7),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: isSelected
                                  ? [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                                  : [],
                            ),
                            child: Text(
                              tabs[index],
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontFamily: 'Prompt_regular',
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color:
                                isSelected ? AppColors.textColor : Color(0xFF757575),
                              ),
                            ),
                          ),
                        );
                      }),
                    )),
                  ),
                ),

                SizedBox(height: 5.h),

                // --- Content Area ---
                Obx(() {
                  switch (controller.selectedIndex.value) {
                    case 0:
                      return  DashboardWidget();
                    case 1:
                      return  FamilyChatWidget();
                    case 2:
                      return PasswordsWidget();
                    default:
                      return  SizedBox();
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


/// ---------------------------- DashboardWidgets ------------------------------

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.w),
      child: Column(
        children: [
          SizedBox(height: 16.h),
          /// weather Card
          _WeatherCard(),
          SizedBox(height: 16.h),

          /// Quick Tasks
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withOpacity(0.08),
                  offset: const Offset(4, 0),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
              border: Border.all(color: const Color(0xFF757575).withOpacity(0.2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset("assets/icons/quickIcon.svg", width: 24.w, height: 24.h, color: Colors.green,),
                          SizedBox(width: 8),
                          Text(
                            "Quick Tasks",
                            style: TextStyle(
                              fontFamily: 'Prompt_regular',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.taskScreen);
                        },
                        child: Text(
                          "View All",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.buttonColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  // Task Items - Dynamic from TaskViewModel
                  Obx(() {
                    final taskViewModel = Get.find<TaskViewModel>();
                    final today = DateTime.now();
                    final todayDate = DateTime(today.year, today.month, today.day);
                    
                    // Get tasks due today or upcoming, excluding completed ones
                    final upcomingTasks = taskViewModel.tasks.where((task) {
                      if (task.status == 'completed') return false;
                      if (task.dueDate == null) return true; // Include tasks without due date
                      final taskDateOnly = DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
                      return taskDateOnly.isAtSameMomentAs(todayDate) || taskDateOnly.isAfter(todayDate);
                    }).toList()
                      ..sort((a, b) {
                        // Sort by due date (nulls last), then by priority
                        if (a.dueDate == null && b.dueDate == null) return 0;
                        if (a.dueDate == null) return 1;
                        if (b.dueDate == null) return -1;
                        final dateCompare = a.dueDate!.compareTo(b.dueDate!);
                        if (dateCompare != 0) return dateCompare;
                        // Same date, sort by priority
                        final priorityOrder = {'High': 0, 'Medium': 1, 'Low': 2};
                        return (priorityOrder[a.priority] ?? 3).compareTo(priorityOrder[b.priority] ?? 3);
                      });
                    
                    final tasksToShow = upcomingTasks.take(3).toList();
                    
                    if (tasksToShow.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Center(
                          child: Text(
                            "No upcoming tasks",
                            style: TextStyle(
                              fontFamily: 'Prompt_regular',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.subHeadingColor,
                            ),
                          ),
                        ),
                      );
                    }
                    
                    return Column(
                      children: tasksToShow.map((task) => Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF000000).withOpacity(0.08),
                          offset: const Offset(4, 0),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Task Header
                          Row(
                            children: [
                              // Checkbox
                              GestureDetector(
                                onTap: () {
                                  // Toggle completion
                                },
                                child: Container(
                                  width: 20.w,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFE5E7EB),
                                      width: 2,
                                    ),
                                    color: task.status == 'completed' ? AppColors.primary : Colors.transparent,
                                  ),
                                  child: task.status == 'completed'
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 12.sp,
                                        )
                                      : null,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              // Lock Icon
                              if (task.isPrivate)
                                Icon(
                                  Icons.lock,
                                  color: AppColors.subHeadingColor,
                                  size: 16.sp,
                                ),
                              SizedBox(width: 8.w),
                              // Task Title
                              Expanded(
                                child: Text(
                                  task.title,
                                  style: TextStyle(
                                    fontFamily: 'Prompt_Bold',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textColor,
                                  ),
                                ),
                              ),
                              // Action Icons
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Open edit modal
                                      showDialog(
                                        context: context,
                                        builder: (context) => CreateTaskModal(task: task),
                                      );
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: AppColors.subHeadingColor,
                                      size: 18.sp,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  GestureDetector(
                                    onTap: () {
                                      // Show delete confirmation
                                      Get.defaultDialog(
                                        title: "Delete Task",
                                        middleText: "Are you sure you want to delete '${task.title}'? This action cannot be undone.",
                                        textConfirm: "Delete",
                                        textCancel: "Cancel",
                                        confirmTextColor: Colors.white,
                                        cancelTextColor: AppColors.textColor,
                                        buttonColor: Colors.red,
                                        onConfirm: () async {
                                          Get.back(); // Close dialog
                                          final taskViewModel = Get.find<TaskViewModel>();
                                          await taskViewModel.deleteTask(task.id);
                                        },
                                        onCancel: () {
                                          Get.back(); // Close dialog
                                        },
                                      );
                                    },
                                    child: Icon(
                                      Icons.delete_outline,
                                      color: AppColors.subHeadingColor,
                                      size: 18.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          // Priority and Points Tags
                          Row(
                            children: [
                              _buildQuickTaskTag(
                                task.priority,
                                _getQuickTaskPriorityColor(task.priority),
                              ),
                              SizedBox(width: 8.w),
                              if (task.points > 0)
                                _buildQuickTaskTag(
                                  "${task.points} points",
                                  const Color(0xFF8B5CF6),
                                ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          // Description
                          if (task.description.isNotEmpty)
                            Text(
                              task.description,
                              style: TextStyle(
                                fontFamily: 'Prompt_regular',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.subHeadingColor,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          // Due Date
                          if (task.dueDate != null) ...[
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: AppColors.subHeadingColor,
                                  size: 14.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  "Due ${_formatQuickTaskDate(task.dueDate!)}${task.dueTime != null ? ' at ${_formatQuickTaskTime(task.dueTime!)}' : ''}",
                                  style: TextStyle(
                                    fontFamily: 'Prompt_regular',
                                    fontSize: 11.sp,
                                    color: AppColors.subHeadingColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                      )).toList(),
                    );
                  }),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          VoiceNotesCard(),
          SizedBox(height: 16.h),
          FamilyDishwasherCard(),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildQuickTaskTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Prompt_regular',
          fontSize: 11.sp,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getQuickTaskPriorityColor(String priority) {
    switch (priority) {
      case "High":
      case "High Priority":
        return const Color(0xFFEF4444);
      case "Medium":
      case "Medium Priority":
        return const Color(0xFFF59E0B);
      case "Low":
      case "Low Priority":
        return const Color(0xFF10B981);
      default:
        return AppColors.subHeadingColor;
    }
  }

  String _formatQuickTaskDate(DateTime date) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final taskDate = DateTime(date.year, date.month, date.day);
    
    if (taskDate.isAtSameMomentAs(todayDate)) {
      return "Today";
    } else if (taskDate.isAtSameMomentAs(todayDate.add(const Duration(days: 1)))) {
      return "Tomorrow";
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return "${months[date.month - 1]} ${date.day}, ${date.year}";
    }
  }

  String _formatQuickTaskTime(String timeStr) {
    // timeStr is in "HH:mm" format
    try {
      final parts = timeStr.split(':');
      if (parts.length == 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        return "$displayHour:${minute.toString().padLeft(2, '0')} $period";
      }
    } catch (e) {
      // If parsing fails, return as is
    }
    return timeStr;
  }
}


/// ---------------------------- FamilyChatWidgets ------------------------------

class FamilyChatWidget extends StatelessWidget {
  const FamilyChatWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Send Message card
        SizedBox(height: 15.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withOpacity(0.08),
                offset: const Offset(4, 0),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
            border: Border.all(color: const Color(0xFF757575).withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    SvgPicture.asset("assets/icons/calendarIcon1.svg", width: 24.w, height: 24.h),
                    SizedBox(width: 8),
                    Text(
                      "Communication",
                      style: TextStyle(
                        fontFamily: 'Prompt_regular',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                ElevatedButton.icon(
                  onPressed: (){
                    Get.dialog(const SendMessagePopup());
                  },
                  icon: Icon(Icons.add, size: 20),
                  label: Text(
                    'Send Message',
                    style: TextStyle(
                      fontFamily: 'Prompt_regular',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.pink[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),

        /// Recent Chats card
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withOpacity(0.08),
                offset: const Offset(4, 0),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
            border: Border.all(color: const Color(0xFF757575).withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    SvgPicture.asset("assets/icons/quickIcon.svg", width: 24.w, height: 24.h, color: Colors.green,),
                    SizedBox(width: 8),
                    Text(
                      "Recent Chats",
                      style: TextStyle(
                        fontFamily: 'Prompt_regular',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return RecentChatCard(
                      title: "Grocery",
                      time: "9:00AM",
                      description: "Ready for the family get-together. Ready for the family get-together. Ready for the family get-together. Ready for the family get-together.",
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),

        /// Family member card
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withOpacity(0.08),
                offset: const Offset(4, 0),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
            border: Border.all(color: const Color(0xFF757575).withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Family Members",
                  style: TextStyle(
                    fontFamily: 'Prompt_regular',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 15),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return FamilyMemberCard(
                      name: "Emily walton",
                      relation: "Parent",
                      isActive: true,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),

        /// Quick Stats
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withOpacity(0.08),
                offset: const Offset(4, 0),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
            border: Border.all(color: const Color(0xFF757575).withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Quick Stats",
                  style: TextStyle(
                    fontFamily: 'Prompt_regular',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Messages Today",
                      style: TextStyle(
                        fontFamily: 'Prompt_regular',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor,
                      ),
                    ),
                    Text(
                      "0",
                      style: TextStyle(
                        fontFamily: 'Prompt_regular',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Active Members",
                      style: TextStyle(
                        fontFamily: 'Prompt_regular',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor,
                      ),
                    ),
                    Text(
                      "4",
                      style: TextStyle(
                        fontFamily: 'Prompt_regular',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "pending Notifications",
                      style: TextStyle(
                        fontFamily: 'Prompt_regular',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor,
                      ),
                    ),
                    Text(
                      "0",
                      style: TextStyle(
                        fontFamily: 'Prompt_regular',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),


              ],
            ),
          ),
        ),
        SizedBox(height: 15.h)
      ],
    );
  }
}


/// ---------------------------- PasswordsWidgets ------------------------------

class PasswordsWidget extends StatefulWidget {
   PasswordsWidget({super.key});

  @override
  State<PasswordsWidget> createState() => _PasswordsWidgetState();
}

class _PasswordsWidgetState extends State<PasswordsWidget> {
  final TextEditingController searchController = TextEditingController();

   int _selectedIndex = 0;

   final List<String> categories = [
     'All',
     'Favourites',
     'Streaming',
     'Banking',
     'School',
     'Shopping',
     'Utilities',
   ];

   final List<int> counts = [1, 1, 1, 0, 0, 0, 0];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withOpacity(0.08),
                offset: const Offset(4, 0),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
            border: Border.all(color: const Color(0xFF757575).withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset("assets/icons/passVaultIcon.svg", width: 24.w, height: 24.h),
                    Text(
                      "Password \nVault",
                      style: TextStyle(
                        fontFamily: 'Prompt_regular',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        Get.dialog(const RemoveAllPasswordsDialog());
                      },
                      icon: Icon(Icons.delete_outline, color: AppColors.buttonColor),
                      label: Text(
                        'Remove All',
                        style: TextStyle(
                          fontFamily: 'Prompt_regular',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.buttonColor,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.pink, width: 1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                    ),

                    ElevatedButton.icon(
                      onPressed: () {
                        Get.dialog(AddNewPasswordDialog());
                      },
                      icon: Icon(Icons.add, color: Colors.white),
                      label: Text('Add', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                SearchField(
                  controller: searchController,
                  onChanged: (value) {
                    // Empty for now, will implement later
                  },
                  hintText: 'Search competitions...',
                ),

                SizedBox(height: 24.h),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF000000).withOpacity(0.08),
                        offset: const Offset(4, 0),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                    border: Border.all(color: const Color(0xFF757575).withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Wrap(
                    spacing: 0.0,
                    runSpacing: 12.0,
                    children: List.generate(categories.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 4 - 16,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  categories[index],
                                  style: TextStyle(
                                    fontFamily: 'Prompt_regular',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: _selectedIndex == index ? AppColors.buttonColor : Colors.black,
                                  ),
                                ),
                                SizedBox(height: 6),
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: _selectedIndex == index ? AppColors.buttonColor : Colors.grey,
                                  child: Text(
                                    '${counts[index]}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Prompt_regular',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: 16.h),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return PasswordSavedCard(
                      title: 'Disney Plus',
                      category: 'Steaming',
                      url: 'disneyplus.com',
                      mail: 'tjtwalton@gmail.com',
                      password: '.............',
                      updatedDate: '22/09/2025',
                      isFavorite: true,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

}




/// -----------------Weather Card Widget ------------------
class _WeatherCard extends StatelessWidget {
  _WeatherCard();

  @override
  Widget build(BuildContext context) {
    final WeatherViewModel weatherViewModel = Get.put(WeatherViewModel());

    return Obx(() {
      final weatherData = weatherViewModel.weatherData.value;
      final isLoading = weatherViewModel.isLoading.value;

      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3A81F7), Color(0xFF2867EC)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: isLoading
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                    ),
                  ),
                )
              : weatherData == null
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: Text(
                          "Unable to load weather data",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Title and Icon Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "Today's Weather (${weatherData.weather.city}, ${weatherData.weather.country})",
                                style: TextStyle(
                                  fontFamily: 'Prompt_regular',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            SvgPicture.asset(
                              "assets/icons/cloudIcon.svg",
                              width: 24.w,
                              height: 24.h,
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          "${weatherData.weather.temperature}°F",
                          style: TextStyle(
                            fontFamily: 'Prompt_Bold',
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          weatherData.weather.description,
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFF5488F2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Color(0xFFFFFFFF).withOpacity(0.2))
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Outfit Suggestion :",
                                style: TextStyle(
                                  fontFamily: 'Prompt_regular',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                weatherData.outfit.summary,
                                style: TextStyle(
                                  fontFamily: 'Prompt_regular',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
        ),
      );
    });
  }
}


/// ---------------- VoiceNotesCard -----------------------
class VoiceNotesCard extends StatelessWidget {
  const VoiceNotesCard({super.key});

  // Define the primary color used for the icon and button
  static const Color primaryPink = Color(0xFFE94B73);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.08),
            offset: const Offset(4, 0),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: const Color(0xFF757575).withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SvgPicture.asset("assets/icons/microPhone.svg", width: 18.w, height: 18.h,),
                        SizedBox(width: 10),
                        Text(
                          "Voice Notes & \nBrain Dump",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.dialog(VoiceNoteDialog());
                  },
                  icon:  Icon(Icons.mic, size: 20),
                  label: Text(
                    'Start Recording',
                    style: TextStyle(
                      fontFamily: 'Prompt_regular',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                    elevation: 3,
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
              decoration: BoxDecoration(
                color: Color(0xFFFAFAFC),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: <Widget>[
                  SvgPicture.asset(
                    "assets/icons/microPhone.svg",
                    width: 24.w,
                    height: 24.h,
                    color: Color(0xFF757575),
                  ),
                  SizedBox(height: 15),

                  Text(
                    "Tap the microphone to start a voice note",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Prompt_regular',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "We'll automatically convert it to text and create tasks!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Prompt_regular',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF757575),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            Center(
              child: OutlinedButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.noteScreen);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Color(0xFF757575).withOpacity(0.2)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                ),
                child: Text(
                  "View All Notes",
                  style: TextStyle(
                    fontFamily: 'Prompt_regular',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

