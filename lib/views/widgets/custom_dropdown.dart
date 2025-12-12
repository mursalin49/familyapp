import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart';

class CustomDropdown<T> extends StatefulWidget {
  final List<DropdownItem<T>> items;
  final T? value;
  final String? hintText;
  final Function(T?)? onChanged;
  final Widget? prefixIcon;
  final double? width;
  final bool enabled;
  final String? Function(T)? itemToString;

  const CustomDropdown({
    super.key,
    required this.items,
    this.value,
    this.hintText,
    this.onChanged,
    this.prefixIcon,
    this.width,
    this.enabled = true,
    this.itemToString,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  bool _showDropdown = false;
  OverlayEntry? _overlayEntry;
  final GlobalKey _buttonKey = GlobalKey();

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  void _toggleDropdown() {
    if (!widget.enabled) return;
    
    if (_showDropdown) {
      _hideDropdown();
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

  void _selectItem(T value) {
    widget.onChanged?.call(value);
    _hideDropdown();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = _buttonKey.currentContext!.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _hideDropdown,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
              ),
            ),
            Positioned(
              top: offset.dy + size.height + 16.h,
              left: offset.dx,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: widget.width ?? size.width,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
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
                    children: widget.items.map((item) {
                      final isSelected = widget.value == item.value;
                      return _buildDropdownItem(item, isSelected);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownItem(DropdownItem<T> item, bool isSelected) {
    return GestureDetector(
      onTap: () => _selectItem(item.value),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEE4973) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            if (isSelected) ...[
              Icon(
                Icons.check,
                color: Colors.white,
                size: 16.sp,
              ),
              SizedBox(width: 8.w),
            ],
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 13.sp,
                  color: isSelected ? Colors.white : AppColors.textColor,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDisplayText() {
    if (widget.value == null) {
      return widget.hintText ?? "Select";
    }
    
    final selectedItem = widget.items.firstWhere(
      (item) => item.value == widget.value,
      orElse: () => DropdownItem<T>(
        value: widget.value!,
        label: widget.itemToString?.call(widget.value!) ?? widget.value.toString(),
      ),
    );
    
    return selectedItem.label;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _buttonKey,
      onTap: _toggleDropdown,
      child: Container(
        width: widget.width,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: widget.enabled ? Colors.white : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFF757575).withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            if (widget.prefixIcon != null) ...[
              widget.prefixIcon!,
              SizedBox(width: 8.w),
            ],
            Expanded(
              child: Text(
                _getDisplayText(),
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 13.sp,
                  color: widget.enabled ? AppColors.textColor : AppColors.subHeadingColor,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Icon(
              _showDropdown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: widget.enabled ? AppColors.subHeadingColor : AppColors.subHeadingColor.withOpacity(0.5),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class DropdownItem<T> {
  final T value;
  final String label;

  const DropdownItem({
    required this.value,
    required this.label,
  });
}

extension DropdownItemExtension<T> on List<T> {
  List<DropdownItem<T>> toDropdownItems(String Function(T) labelBuilder) {
    return map((item) => DropdownItem<T>(
      value: item,
      label: labelBuilder(item),
    )).toList();
  }
}
