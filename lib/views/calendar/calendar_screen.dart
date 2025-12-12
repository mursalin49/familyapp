import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../models/calendar_event.dart';
import '../../models/event_model.dart';
import '../../viewmodels/event_view_model.dart';
import '../widgets/app_header.dart';
import 'create_event_modal.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late PageController _pageController;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarView _currentView = CalendarView.month;
  
  final EventViewModel _eventViewModel = Get.put(EventViewModel());

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }
  
  // Convert EventModel to CalendarEvent for display
  List<CalendarEvent> _getCalendarEvents() {
    // Access the observable to ensure Obx tracks changes
    final events = _eventViewModel.events;
    return events.map((event) {
      // Parse startTime from "HH:mm" to TimeOfDay
      TimeOfDay time = const TimeOfDay(hour: 0, minute: 0);
      if (event.startTime != null && event.startTime!.isNotEmpty) {
        try {
          final parts = event.startTime!.split(':');
          if (parts.length == 2) {
            time = TimeOfDay(
              hour: int.parse(parts[0]),
              minute: int.parse(parts[1]),
            );
          }
        } catch (e) {
          // Use default time if parsing fails
        }
      }
      
      // Determine color based on visibility
      Color color = const Color(0xFF3B82F6); // Default blue
      if (event.visibility == 'private') {
        color = const Color(0xFFEF4444); // Red for private
      }
      
      return CalendarEvent(
        id: event.id,
        title: event.title,
        description: event.description,
        date: event.startDate,
        time: time,
        color: color,
        location: event.location,
        isAllDay: event.allDayEvent,
      );
    }).toList();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // App Header
          const AppHeader(),
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Page Title Section
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    child: Row(
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.calendar_today_outlined,
                            color: AppColors.primary,
                            size: 18.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Family Calendar",
                                style: TextStyle(
                                  fontFamily: 'Prompt_Bold',
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textColor,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "Manage your family's schedule and events",
                                style: TextStyle(
                                  fontFamily: 'Prompt_regular',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.subHeadingColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Calendar Content
                  _buildCalendarContent(),
                  SizedBox(height: 16.h),
                  // Today's Events Card
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFF757575).withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF000000).withOpacity(0.05),
                          offset: const Offset(0, 2),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: _buildTodaysEventsCard(),
                  ),
                  SizedBox(height: 12.h),
                  // Calendar Stats Card
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFF757575).withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF000000).withOpacity(0.05),
                          offset: const Offset(0, 2),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: _buildCalendarStatsCard(),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFF757575).withOpacity(0.2)),
        ),
        child: Icon(
          icon,
          color: AppColors.textColor,
          size: 16.sp,
        ),
      ),
    );
  }

  Widget _buildViewToggleButton(String label, CalendarView view) {
    final isSelected = _currentView == view;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentView = view;
            // When switching to week view, ensure focusedDay is set to current week
            if (view == CalendarView.week && _focusedDay != DateTime.now()) {
              _focusedDay = DateTime.now();
            }
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(6.r),
            boxShadow: isSelected ? [
              BoxShadow(
                color: const Color(0xFF000000).withOpacity(0.05),
                offset: const Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 0,
              ),
            ] : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Prompt_regular',
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: isSelected ? AppColors.textColor : AppColors.subHeadingColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarContent() {
    switch (_currentView) {
      case CalendarView.month:
        return _buildMonthView();
      case CalendarView.week:
        return _buildWeekView();
      case CalendarView.day:
        return _buildDayView();
      case CalendarView.list:
        return _buildListView();
    }
  }

  Widget _buildMonthView() {
    return Column(
      children: [
        // Month Navigation
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Row(
            children: [
              Text(
                _getMonthYearString(_focusedDay),
                style: TextStyle(
                  fontFamily: 'Prompt_Bold',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
              const Spacer(),
              // Navigation Buttons
              Row(
                children: [
                  _buildNavButton(Icons.chevron_left, () {
                    setState(() {
                      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
                    });
                  }),
                  SizedBox(width: 8.w),
                  _buildNavButton(Icons.chevron_right, () {
                    setState(() {
                      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
                    });
                  }),
                ],
              ),
            ],
          ),
        ),
        // View Toggle
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFF757575).withOpacity(0.2)),
          ),
          child: Row(
            children: [
              _buildViewToggleButton("Month", CalendarView.month),
              _buildViewToggleButton("Week", CalendarView.week),
              _buildViewToggleButton("Day", CalendarView.day),
              _buildViewToggleButton("List", CalendarView.list),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        // Calendar Grid
        Container(
          height: 450.h, // Increased height for calendar grid
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFF757575).withOpacity(0.2)),
          ),
          child: _buildCalendarGrid(),
        ),
        SizedBox(height: 16.h),
        // Selected Day Events
        Obx(() {
          final events = _getEventsForDay(_selectedDay);
          if (events.isEmpty) return const SizedBox.shrink();
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFF757575).withOpacity(0.2)),
            ),
            child: _buildSelectedDayEvents(),
          );
        }),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    final firstDayOfWeek = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    return Column(
      children: [
        // Weekday Headers
        Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Row(
            children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                .map((day) => Expanded(
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Prompt_regular',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.subHeadingColor,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        // Calendar Days
        GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 0.8, // Increased height for better event display
          ),
          itemCount: 42, // 6 weeks * 7 days
          itemBuilder: (context, index) {
              final dayOffset = index - firstDayOfWeek + 1;
              final day = dayOffset > 0 && dayOffset <= daysInMonth ? dayOffset : null;
              final isSelected = day != null &&
                  _selectedDay.year == _focusedDay.year &&
                  _selectedDay.month == _focusedDay.month &&
                  _selectedDay.day == day;
              final isToday = day != null &&
                  DateTime.now().year == _focusedDay.year &&
                  DateTime.now().month == _focusedDay.month &&
                  DateTime.now().day == day;
              final isCurrentMonth = day != null;
              final isPreviousMonth = dayOffset <= 0;
              final isNextMonth = dayOffset > daysInMonth;

              return GestureDetector(
                onTap: () {
                  if (day != null) {
                    setState(() {
                      _selectedDay = DateTime(_focusedDay.year, _focusedDay.month, day);
                    });
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: isSelected 
                          ? AppColors.primary 
                          : const Color(0xFF757575).withOpacity(0.2),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: day != null
                      ? Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Day Number
                              Text(
                                day.toString(),
                                style: TextStyle(
                                  fontFamily: 'Prompt_regular',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? AppColors.primary
                                      : isPreviousMonth || isNextMonth
                                          ? AppColors.subHeadingColor.withOpacity(0.5)
                                          : AppColors.textColor,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              // Event Indicators
                              if (_hasEventsOnDay(DateTime(_focusedDay.year, _focusedDay.month, day)))
                                Expanded(
                                  child: _buildEventIndicators(DateTime(_focusedDay.year, _focusedDay.month, day)),
                                ),
                            ],
                          ),
                        )
                      : null,
                ),
              );
            },
        ),
      ],
    );
  }

  Widget _buildEventIndicators(DateTime day) {
    final events = _getEventsForDay(day);
    if (events.isEmpty) return const SizedBox.shrink();
    
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: events.take(2).map((event) {
          final timeString = event.isAllDay 
              ? 'All Day'
              : '${event.time.hour.toString().padLeft(2, '0')}:${event.time.minute.toString().padLeft(2, '0')}';
          
          return Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 1.h),
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: event.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(2.r),
              border: Border.all(
                color: event.color.withOpacity(0.3),
                width: 0.5,
              ),
            ),
            child: Text(
              timeString,
              style: TextStyle(
                fontFamily: 'Prompt_regular',
                fontSize: 8.sp,
                fontWeight: FontWeight.w500,
                color: event.color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSelectedDayEvents() {
    final events = _getEventsForDay(_selectedDay);
    if (events.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Events for ${_selectedDay.day} ${_getMonthName(_selectedDay.month)}",
          style: TextStyle(
            fontFamily: 'Prompt_Bold',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        SizedBox(height: 12.h),
        ...events.map((event) => Container(
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: event.color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: event.color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 4.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: event.color,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: TextStyle(
                        fontFamily: 'Prompt_regular',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${event.time.hour.toString().padLeft(2, '0')}:${event.time.minute.toString().padLeft(2, '0')} • ${event.description}',
                      style: TextStyle(
                        fontFamily: 'Prompt_regular',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.subHeadingColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  Widget _buildTodaysEventsCard() {
    return Obx(() {
      // Get today's events from the loaded events
      final todaysEvents = _getEventsForDay(DateTime.now());
      
      // Also check if events are still loading
      if (_eventViewModel.isLoading.value) {
        return Row(
          children: [
            Icon(
              Icons.access_time_outlined,
              color: AppColors.textColor,
              size: 20.sp,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Events",
                    style: TextStyle(
                      fontFamily: 'Prompt_Bold',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Loading...",
                    style: TextStyle(
                      fontFamily: 'Prompt_regular',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.subHeadingColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }
      
      return Row(
        children: [
          Icon(
            Icons.access_time_outlined,
            color: AppColors.textColor,
            size: 20.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Events",
                  style: TextStyle(
                    fontFamily: 'Prompt_Bold',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  todaysEvents.isEmpty 
                      ? "No events scheduled for today"
                      : "${todaysEvents.length} event${todaysEvents.length == 1 ? '' : 's'} scheduled for today",
                  style: TextStyle(
                    fontFamily: 'Prompt_regular',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.subHeadingColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCalendarStatsCard() {
    return Obx(() {
      final calendarEvents = _getCalendarEvents();
      final totalEvents = calendarEvents.length;
      final thisWeekEvents = _getThisWeekEventsCount();
      final todayEvents = _getEventsForDay(DateTime.now()).length;
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Calendar Stats",
            style: TextStyle(
              fontFamily: 'Prompt_Bold',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(height: 16.h),
          _buildStatRow("Total Events", totalEvents.toString()),
          SizedBox(height: 12.h),
          _buildStatRow("This Week", thisWeekEvents.toString()),
          SizedBox(height: 12.h),
          _buildStatRow("Today", todayEvents.toString()),
        ],
      );
    });
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Prompt_regular',
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Prompt_Bold',
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
      ],
    );
  }

  int _getThisWeekEventsCount() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    final calendarEvents = _getCalendarEvents();
    return calendarEvents.where((event) {
      return event.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
             event.date.isBefore(endOfWeek.add(const Duration(days: 1)));
    }).length;
  }

  Widget _buildWeekView() {
    // Calculate the start of the week (Sunday)
    // weekday returns 1-7 (Monday=1, Sunday=7), we want Sunday=0
    // If it's Sunday (weekday == 7), daysFromSunday should be 0
    // If it's Monday (weekday == 1), daysFromSunday should be 1, etc.
    final daysFromSunday = _focusedDay.weekday == 7 ? 0 : _focusedDay.weekday;
    final startOfWeek = _focusedDay.subtract(Duration(days: daysFromSunday));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return SingleChildScrollView(
      child: Column(
      children: [
        // Week Navigation
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "${_getMonthName(startOfWeek.month)} ${startOfWeek.day} - ${_getMonthName(endOfWeek.month)} ${endOfWeek.day}, ${startOfWeek.year}",
                  style: TextStyle(
                    fontFamily: 'Prompt_Bold',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 12.w),
              // Navigation Buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNavButton(Icons.chevron_left, () {
                    setState(() {
                      _focusedDay = _focusedDay.subtract(const Duration(days: 7));
                    });
                  }),
                  SizedBox(width: 8.w),
                  _buildNavButton(Icons.chevron_right, () {
                    setState(() {
                      _focusedDay = _focusedDay.add(const Duration(days: 7));
                    });
                  }),
                ],
              ),
            ],
          ),
        ),
        // View Toggle
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFF757575).withOpacity(0.2)),
          ),
          child: Row(
            children: [
              _buildViewToggleButton("Month", CalendarView.month),
              _buildViewToggleButton("Week", CalendarView.week),
              _buildViewToggleButton("Day", CalendarView.day),
              _buildViewToggleButton("List", CalendarView.list),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        // Week Calendar Grid
        Container(
          height: 500.h, // Fixed height for week grid
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFF757575).withOpacity(0.2)),
          ),
          child: _buildWeekGrid(startOfWeek),
        ),
        SizedBox(height: 20.h),
      ],
      ),
    );
  }

  Widget _buildWeekGrid(DateTime startOfWeek) {
    return Column(
      children: [
        // Weekday Headers
        Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Row(
            children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                .map((day) => Expanded(
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Prompt_regular',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.subHeadingColor,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        // Week Dates
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            children: List.generate(7, (index) {
              final day = startOfWeek.add(Duration(days: index));
              final isSelected = day.year == _selectedDay.year &&
                  day.month == _selectedDay.month &&
                  day.day == _selectedDay.day;
              
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDay = day;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      day.day.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Prompt_regular',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textColor,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        // Event Areas
        Container(
          height: 350.h, // Fixed height for event areas
          child: Row(
            children: List.generate(7, (index) {
              final day = startOfWeek.add(Duration(days: index));
              final isSelected = day.year == _selectedDay.year &&
                  day.month == _selectedDay.month &&
                  day.day == _selectedDay.day;
              final hasEvents = _hasEventsOnDay(day);
              
              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: isSelected 
                          ? AppColors.primary 
                          : const Color(0xFF757575).withOpacity(0.2),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => CreateEventModal(selectedDate: day),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (hasEvents)
                            ..._getEventsForDay(day).map((event) => Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(bottom: 4.h),
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: event.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.r),
                                border: Border.all(
                                  color: event.color.withOpacity(0.3),
                                  width: 0.5,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${event.time.hour.toString().padLeft(2, '0')}:${event.time.minute.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      fontFamily: 'Prompt_regular',
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: event.color,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    event.title,
                                    style: TextStyle(
                                      fontFamily: 'Prompt_regular',
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            )).toList(),
                          if (!hasEvents)
                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_circle_outline,
                                      color: AppColors.subHeadingColor.withOpacity(0.6),
                                      size: 24.sp,
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      "Add Event",
                                      style: TextStyle(
                                        fontFamily: 'Prompt_regular',
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.subHeadingColor.withOpacity(0.8),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildDayView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Day Navigation
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    "${_getWeekdayName(_selectedDay.weekday)}, ${_getMonthName(_selectedDay.month)} ${_selectedDay.day}, ${_selectedDay.year}",
                    style: TextStyle(
                      fontFamily: 'Prompt_Bold',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 12.w),
                // Navigation Buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildNavButton(Icons.chevron_left, () {
                      setState(() {
                        _selectedDay = _selectedDay.subtract(const Duration(days: 1));
                      });
                    }),
                    SizedBox(width: 8.w),
                    _buildNavButton(Icons.chevron_right, () {
                      setState(() {
                        _selectedDay = _selectedDay.add(const Duration(days: 1));
                      });
                    }),
                  ],
                ),
              ],
            ),
          ),
          // View Toggle
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFF757575).withOpacity(0.2)),
            ),
            child: Row(
              children: [
                _buildViewToggleButton("Month", CalendarView.month),
                _buildViewToggleButton("Week", CalendarView.week),
                _buildViewToggleButton("Day", CalendarView.day),
                _buildViewToggleButton("List", CalendarView.list),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          // Back to Month Button
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentView = CalendarView.month;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.primary,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "Back to Month",
                        style: TextStyle(
                          fontFamily: 'Prompt_regular',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  "${_getEventsForDay(_selectedDay).length} events scheduled",
                  style: TextStyle(
                    fontFamily: 'Prompt_regular',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.subHeadingColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          // Add Event Button
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            child: SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => CreateEventModal(selectedDate: _selectedDay),
                  );
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20.sp,
                ),
                label: Text(
                  "Add Event",
                  style: TextStyle(
                    fontFamily: 'Prompt_regular',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          // Daily Schedule
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFF757575).withOpacity(0.2)),
            ),
            child: _buildDailySchedule(),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildListView() {
    final allEvents = _getAllEvents();
    
    return SingleChildScrollView(
      child: Column(
        children: [
          // List Navigation Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Row(
              children: [
                Icon(
                  Icons.list_alt,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    "Event List",
                    style: TextStyle(
                      fontFamily: 'Prompt_Bold',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                Text(
                  "${allEvents.length} events",
                  style: TextStyle(
                    fontFamily: 'Prompt_regular',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.subHeadingColor,
                  ),
                ),
              ],
            ),
          ),
          // View Toggle
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFF757575).withOpacity(0.2)),
            ),
            child: Row(
              children: [
                _buildViewToggleButton("Month", CalendarView.month),
                _buildViewToggleButton("Week", CalendarView.week),
                _buildViewToggleButton("Day", CalendarView.day),
                _buildViewToggleButton("List", CalendarView.list),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          // Events List
          if (allEvents.isEmpty)
            _buildEmptyState()
          else
            _buildEventsList(allEvents),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(40.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF757575).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_note_outlined,
            size: 48.sp,
            color: AppColors.subHeadingColor.withOpacity(0.4),
          ),
          SizedBox(height: 16.h),
          Text(
            "No events scheduled",
            style: TextStyle(
              fontFamily: 'Prompt_regular',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.subHeadingColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Tap the + button to add your first event",
            style: TextStyle(
              fontFamily: 'Prompt_regular',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.subHeadingColor.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(List<CalendarEvent> events) {
    // Group events by date
    final groupedEvents = <DateTime, List<CalendarEvent>>{};
    for (final event in events) {
      final eventDate = DateTime(event.date.year, event.date.month, event.date.day);
      groupedEvents.putIfAbsent(eventDate, () => []).add(event);
    }

    // Sort dates
    final sortedDates = groupedEvents.keys.toList()..sort();

    return Column(
      children: sortedDates.map((date) {
        final dayEvents = groupedEvents[date]!;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFF757575).withOpacity(0.2)),
          ),
          child: Column(
            children: [
              // Date Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      _getMonthName(date.month),
                      style: TextStyle(
                        fontFamily: 'Prompt_Bold',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "${date.day}",
                      style: TextStyle(
                        fontFamily: 'Prompt_Bold',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "${date.year}",
                      style: TextStyle(
                        fontFamily: 'Prompt_regular',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.subHeadingColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "${dayEvents.length} event${dayEvents.length == 1 ? '' : 's'}",
                      style: TextStyle(
                        fontFamily: 'Prompt_regular',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.subHeadingColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Events for this date
              ...dayEvents.asMap().entries.map((entry) {
                final index = entry.key;
                final event = entry.value;
                final isLast = index == dayEvents.length - 1;
                
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    border: isLast ? null : Border(
                      bottom: BorderSide(
                        color: const Color(0xFF757575).withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Time
                      Container(
                        width: 60.w,
                        child: Text(
                          _formatTime(event.time),
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Event Title
                      Expanded(
                        child: Text(
                          event.title,
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                      // Event Type Indicator
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: _getEventColor(event.title),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<CalendarEvent> _getAllEvents() {
    return _getCalendarEvents().where((event) {
      return event.date.isAfter(DateTime.now().subtract(const Duration(days: 1))) ||
             event.date.isAtSameMomentAs(DateTime.now());
    }).toList();
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    
    if (hour == 0) return '12:$minute AM';
    if (hour < 12) return '$hour:$minute AM';
    if (hour == 12) return '12:$minute PM';
    return '${hour - 12}:$minute PM';
  }

  Color _getEventColor(String title) {
    // Simple color assignment based on event type
    if (title.toLowerCase().contains('doctor') || title.toLowerCase().contains('appointment')) {
      return Colors.red;
    } else if (title.toLowerCase().contains('school') || title.toLowerCase().contains('meeting')) {
      return Colors.blue;
    } else if (title.toLowerCase().contains('deadline') || title.toLowerCase().contains('important')) {
      return Colors.orange;
    } else {
      return AppColors.primary;
    }
  }

  Widget _buildDailySchedule() {
    final events = _getEventsForDay(_selectedDay);
    
    return Column(
      children: [
        // Generate hourly schedule from 12 AM to 11 PM
        ...List.generate(24, (index) {
          final hour = index;
          final hourEvents = events.where((event) {
            return event.time.hour == hour;
          }).toList();
          
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFF757575).withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Time Label
                SizedBox(
                  width: 60.w,
                  child: Text(
                    _formatHour(hour),
                    style: TextStyle(
                      fontFamily: 'Prompt_regular',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.subHeadingColor,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                // Events or "No events"
                Expanded(
                  child: hourEvents.isEmpty
                      ? Text(
                          "No events",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.subHeadingColor.withOpacity(0.6),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: hourEvents.map((event) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 4.h),
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                event.title,
                                style: TextStyle(
                                  fontFamily: 'Prompt_regular',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  String _getWeekdayName(int weekday) {
    const weekdays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return weekdays[weekday % 7];
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12 AM';
    if (hour < 12) return '$hour AM';
    if (hour == 12) return '12 PM';
    return '${hour - 12} PM';
  }

  String _getMonthYearString(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  bool _hasEventsOnDay(DateTime day) {
    final calendarEvents = _getCalendarEvents();
    // Normalize dates to compare only year, month, day (ignore time)
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return calendarEvents.any((event) {
      final normalizedEventDate = DateTime(event.date.year, event.date.month, event.date.day);
      return normalizedEventDate.isAtSameMomentAs(normalizedDay);
    });
  }

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    final calendarEvents = _getCalendarEvents();
    // Normalize dates to compare only year, month, day (ignore time)
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return calendarEvents.where((event) {
      final normalizedEventDate = DateTime(event.date.year, event.date.month, event.date.day);
      return normalizedEventDate.isAtSameMomentAs(normalizedDay);
    }).toList();
  }
}