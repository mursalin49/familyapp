import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_icons.dart';
import '../calendar/calendar_screen.dart';
import '../home/home_screen.dart';
import '../meals/grocery_list_screen.dart';
import '../meals/meals_screen.dart';
import '../notes/notes_screen.dart';
import '../task/tasks_screen.dart';



class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int selectedIndex = 0;

  void navigationItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    HomeScreen(),
    const CalendarScreen(),
    const TaskScreen(),
    const NotesScreen(),
    const MealsScreen(),
    const GroceryListScreen(),
    // const HomeScreen(),

  ];

  // Create nav items in a getter
  List<BottomNavigationBarItem> get _navItems => [
    _navItem(AppIcons.homeIcon, "Home", 0),
    _navItem(AppIcons.calendarIcon, "Calendar", 1),
    _navItem(AppIcons.tasksIcon, "Tasks", 2),
    _navItem(AppIcons.notes, "Notes", 3),
    _navItem(AppIcons.meals, "Meals", 4),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selectedIndex],

      bottomNavigationBar: Container(
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
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 95.h,
            child: BottomNavigationBar(
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              currentIndex: selectedIndex,
              selectedItemColor: AppColors.buttonColor,
              selectedLabelStyle: TextStyle(
                fontFamily: 'SegeoUi_bold',
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
                color: AppColors.buttonColor,
              ),
              unselectedLabelStyle: TextStyle(
                fontFamily: 'SegeoUi_bold',
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
                color: AppColors.textColor,
              ),
              showSelectedLabels: true,
              unselectedItemColor: AppColors.textColor,
              backgroundColor: Colors.transparent,
              iconSize: 24.sp,
              onTap: navigationItemTap,
              items: _navItems,
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem(
      String iconPath,
      String label,
      int index,
      ) {

    final bool isSelected = selectedIndex == index;
    final Color iconColor = isSelected
        ? AppColors.buttonColor
        : AppColors.textColor;

    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        width: 24.w,
        height: 24.h,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      ),
      label: label,
    );
  }
}
