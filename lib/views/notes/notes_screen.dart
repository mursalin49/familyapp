import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/app_colors.dart';
import '../../theme/app_textstyles.dart';
import '../widgets/app_header.dart';
import 'VoiceNotesScreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NotesTabControllerX extends GetxController {
  var selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  bool showTodayNotes = true;
  final NotesTabControllerX controller = Get.put(NotesTabControllerX());
  final List<String> tabs = ["Dashboard", "Voice Notes"];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  List<Map<String, String>> notes = [
    {"title": "Grocery", "content": "Need to pick the grocery items"},
  ];

  final TextEditingController searchController = TextEditingController();

  void _showCreateNoteDialog({bool isEdit = false, int? index}) {
    if (isEdit && index != null) {
      titleController.text = notes[index]["title"] ?? "";
      contentController.text = notes[index]["content"] ?? "";
    } else {
      titleController.clear();
      contentController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and close button
              Stack(
                children: [
                  Center(
                    child: Text(
                      isEdit ? "Edit Text Note" : "Create New Text Note",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontFamily: 'Prompt_Bold',
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(Icons.close, size: 24.sp, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 12.h),
              // // Prompt text
              // Center(
              //   child: Text(
              //     "Ready to record your voice note?",
              //     style: TextStyle(
              //       fontSize: 12.sp,
              //       fontWeight: FontWeight.w400,
              //       color: AppColors.subHeadingColor,
              //       fontFamily: 'Prompt_regular',
              //     ),
              //   ),
              // ),
              SizedBox(height: 20.h),
              // Note title input
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Note title...",
                  hintStyle: TextStyle(
                    color: AppColors.subHeadingColor,
                    fontSize: 14.sp,
                    fontFamily: 'Prompt_regular',
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: const Color(0xFF757575).withOpacity(0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: const Color(0xFF757575).withOpacity(0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                ),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'Prompt_regular',
                ),
              ),
              SizedBox(height: 16.h),
              // Note content input
              TextField(
                controller: contentController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Note content...",
                  hintStyle: TextStyle(
                    color: AppColors.subHeadingColor,
                    fontSize: 14.sp,
                    fontFamily: 'Prompt_regular',
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: const Color(0xFF757575).withOpacity(0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: const Color(0xFF757575).withOpacity(0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                ),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'Prompt_regular',
                ),
              ),
              SizedBox(height: 24.h),
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Cancel button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: BorderSide(color: const Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Prompt_regular',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Create Note button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (isEdit && index != null) {
                            notes[index]["title"] = titleController.text;
                            notes[index]["content"] = contentController.text;
                          } else {
                            notes.add({
                              "title": titleController.text,
                              "content": contentController.text,
                            });
                          }
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        elevation: 0,
                      ),
                      child: Text(
                        isEdit ? "Save Note" : "Create Note",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Prompt_regular',
                        ),
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

  Widget _buildTabs() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
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
        children: List.generate(tabs.length, (index) {
          final bool isSelected =
              controller.selectedIndex.value == index;
          return Expanded(
            child: GestureDetector(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      index == 0 ? "assets/icons/dash.svg" : "assets/icons/micro.svg",
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        isSelected ? AppColors.textColor : AppColors.subHeadingColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
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
                  ],
                ),
              ),
            ),
          );
        }),
      )),
    );
  }

  Widget _buildDashboardNotes() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      // Since the ExpansionTile is a single widget that contains all notes,
      // itemCount should probably be 1, as it is.
      itemCount: 1,
      itemBuilder: (context, _) {
        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            initiallyExpanded: showTodayNotes,
            onExpansionChanged: (v) => setState(() => showTodayNotes = v),
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                "Today (${notes.length})",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            childrenPadding: EdgeInsets.zero,
            children: [
              ...notes.asMap().entries.map((entry) {
                // Use entry.key which is the index (int)
                final int index = entry.key;
                final note = entry.value;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFF757575).withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0, right: 12.0),
                          child: SvgPicture.asset(
                            "assets/icons/file.svg",
                            height: 24,
                            colorFilter: ColorFilter.mode(
                                AppColors.primary, BlendMode.srcIn),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note["title"] ?? "",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                note["content"] ?? "",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textDark.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "30 minutes ago",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text("•",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                  const SizedBox(width: 4),
                                  Text(
                                    "unknown",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: SvgPicture.asset(
                                "assets/icons/edit.svg",
                                height: 20,
                              ),
                              onPressed: () =>
                                  _showCreateNoteDialog(isEdit: true, index: index),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: SvgPicture.asset(
                                "assets/icons/delate.svg",
                                height: 20,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: const Text("Delete Note"),
                                    content: const Text(
                                        "Are you sure you want to delete this note?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            notes.removeAt(index);
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(
                                              color: Colors.redAccent),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _openVoiceNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Record Voice Note"),
        content: const Text("Voice recording feature coming soon 🎤"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      body: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Text("Notes", style: AppTextStyles.title3),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Voice notes and text notes for your family",
                      style: AppTextStyles.header),
                ),
                const SizedBox(height: 10),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: TextField(
                //     decoration: InputDecoration(
                //       hintText: "Search notes...",
                //       prefixIcon: Icon(Icons.search,
                //           color: AppColors.textDark.withOpacity(0.7)),
                //       filled: true,
                //       fillColor: AppColors.white,
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(12),
                //         borderSide: BorderSide.none,
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SearchField(
                    onChanged: (value) {
                      // Empty for now, will implement later
                    },
                    controller: searchController,
                    hintText: 'Search competitions...',
                  ),
                ),

                const SizedBox(height: 18),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: _buildTabs(),
                ),
                const SizedBox(height: 14),
                // Only show button for Text Notes tab, not Voice Notes
                Obx(() {
                  if (controller.selectedIndex.value == 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize: const Size(double.infinity, 44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: SvgPicture.asset(
                          "assets/icons/add.svg",
                          height: 20,
                          colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                        label: const Text(
                          "Create New Text Note",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        onPressed: _showCreateNoteDialog,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
                Expanded(
                  child: Obx(() => controller.selectedIndex.value == 1 
                    ? const VoiceNotesScreen() 
                    : _buildDashboardNotes()),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String hintText;

  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14.sp,
          fontFamily: 'Prompt_regular',
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppColors.grey,
            fontSize: 14.sp,
            fontFamily: 'Prompt_regular',
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.grey,
            size: 28.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Color(0xFF757575).withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
        ),
      ),
    );
  }
}

