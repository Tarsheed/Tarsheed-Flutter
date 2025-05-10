import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';

class CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CircularIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.w,
      height: 48.h,
      decoration:  BoxDecoration(
        color: ColorManager.customLightBlue,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: ColorManager.primary, size: 28.sp),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
