import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import '../../../../../generated/l10n.dart';

class BuildInfoCard extends StatelessWidget {
  final Widget? iconWidget;
  final IconData? icon;
  final String? title;
  final String? value;
  final String? percentage;
  final bool? isDecrease;
  final Color? color;
  final String? roomName;

  const BuildInfoCard({
    this.iconWidget,
    this.icon,
    required this.title,
    required this.value,
    this.percentage,
    this.isDecrease,
    this.color,
    this.roomName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorManager.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: color ?? ColorManager.primary,
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.all(8.w),
              child: iconWidget ??
                  Icon(
                    icon ?? Icons.info,
                    color: ColorManager.white,
                    size: 24.sp,
                  ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? S.of(context).noTitle,
                    style: TextStyle(
                      color: ColorManager.darkGrey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    value ?? S.of(context).noValue,
                    style: TextStyle(
                      color: ColorManager.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
            if (roomName != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: ColorManager.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  roomName!,
                  style: TextStyle(
                    color: ColorManager.primary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      (isDecrease ?? true)
                          ? Icons.arrow_downward_rounded
                          : Icons.arrow_upward_rounded,
                      color: (isDecrease ?? true)
                          ? (color ?? ColorManager.primary)
                          : ColorManager.red,
                      size: 20.sp,
                      weight: 800,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      percentage ?? '0%',
                      style: TextStyle(
                        color: (isDecrease ?? true)
                            ? (color ?? ColorManager.primary)
                            : ColorManager.red,
                        fontWeight: FontWeight.w700,
                        fontSize: 20.sp,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}