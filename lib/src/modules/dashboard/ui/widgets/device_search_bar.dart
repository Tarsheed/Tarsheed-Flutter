import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';

class DeviceSearchBar extends StatelessWidget {
  const DeviceSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: ColorManager.grey300),
        ),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
        child: Row(
          children: [
            Icon(Icons.search, color: ColorManager.grey200, size: 20.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: TextField(
                autofocus: false,
                decoration: InputDecoration(
                  hintText: S.of(context).searchDevices,
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
            SizedBox(width: 10.w),
            Icon(Icons.grid_view, color: ColorManager.grey, size: 20.sp),
          ],
        ),
      ),
    );
  }
}