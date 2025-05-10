import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';

class UsageCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;

  const UsageCard({
    Key? key,
    required this.title,
    required this.value,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 164.w,
      height: 64.h,
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black12,
            blurRadius: 4.r,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding:  EdgeInsets.all(4.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
                color: ColorManager.black),
          ),
          Text(
            value,
            style: TextStyle(
              color: ColorManager.primary,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 3.h),
          if (subtitle != null)
            Text(
              subtitle!,
              style: TextStyle(
                  color: ColorManager.black,
                  fontSize: 5.sp,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
