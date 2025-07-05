import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserGender extends StatelessWidget {
  final String? selected;
  final Function(String icon) onIconSelected;

  const UserGender({
    super.key,
    required this.selected,
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _iconBox('user_icon1', selected, onIconSelected),
        SizedBox(width: 30.w),
        _iconBox('user_icon2', selected, onIconSelected),
      ],
    );
  }

  Widget _iconBox(String icon, String? selected, Function(String) onTap) {
    return GestureDetector(
      onTap: () => onTap(icon),
      child: Container(
        decoration: BoxDecoration(
          border: selected == icon
              ? Border.all(color: Colors.white, width: 3.0)
              : null,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Image.asset('assets/images/$icon.png', width: 80.w, height: 80.h),
      ),
    );
  }
}
