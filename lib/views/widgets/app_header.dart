import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../settings/settings_screen.dart';

class AppHeader extends StatefulWidget {
  const AppHeader({super.key});

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  bool _showDropdown = false;
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_showDropdown) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } else {
      _showDropdown = true;
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
    setState(() {});
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _showDropdown = false;
    setState(() {});
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _hideDropdown,
        child: Stack(
          children: [
            // Full screen tap to close
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
              ),
            ),
            // Dropdown menu
            Positioned(
              top: offset.dy + size.height - 8.h,
              right: 16.w,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 200.w,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF000000).withOpacity(0.1),
                        offset: const Offset(0, 4),
                        blurRadius: 12,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMenuItem(
                        icon: Icons.menu_book_outlined,
                        title: "Tutorials & Help",
                        onTap: () {
                          _hideDropdown();
                          // TODO: Navigate to tutorials
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.smart_toy_outlined,
                        title: "AI Assistant",
                        onTap: () {
                          _hideDropdown();
                          // TODO: Navigate to AI assistant
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.crop_outlined,
                        title: "Subscription",
                        onTap: () {
                          _hideDropdown();
                          // TODO: Navigate to subscription
                        },
                      ),
                      const Divider(height: 1, color: Color(0xFFE5E7EB)),
                      _buildMenuItem(
                        icon: Icons.settings_outlined,
                        title: "App Settings",
                        onTap: () {
                          _hideDropdown();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                      // _buildMenuItem(
                      //   icon: Icons.people_outline,
                      //   title: "Family Settings",
                      //   onTap: () {
                      //     _hideDropdown();
                      //     // TODO: Navigate to family settings
                      //   },
                      // ),
                      // const Divider(height: 1, color: Color(0xFFE5E7EB)),
                      _buildMenuItem(
                        icon: Icons.logout,
                        title: "Sign Out",
                        textColor: Colors.red,
                        iconColor: Colors.red,
                        onTap: () {
                          _hideDropdown();
                          // TODO: Implement sign out
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20.sp,
                color: iconColor ?? AppColors.textColor,
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: textColor ?? AppColors.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 65.h, bottom: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset("assets/icons/appIcon.svg"),
                SizedBox(width: 10.w),
                Text(
                    "THE MOM APP",
                    style: GoogleFonts.montserrat(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      //color: AppColors.textColor,
                      color: Colors.black,
                      letterSpacing: 16.sp * 0.1,
                    ),
                ),
              ],
            ),
            Row(
              children: [
                InkWell(
                  onTap: (){},
                  child: SvgPicture.asset("assets/icons/notificationIcon.svg", width: 30.w, height: 30.h),
                ),
                SizedBox(width: 8.w),
                InkWell(
                  onTap: (){},
                  child: SvgPicture.asset("assets/icons/profileIcon.svg", width: 19.w, height: 19.h ),
                ),
                SizedBox(width: 5.w),
                Text(
                    "TJ",
                    style: TextStyle(
                      fontFamily: 'Prompt_regular',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                    )
                ),
                SizedBox(width: 10.w),
                InkWell(
                  onTap: _toggleDropdown,
                  child: SvgPicture.asset("assets/icons/settingsIcon.svg", width: 20.w, height: 20.h),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
