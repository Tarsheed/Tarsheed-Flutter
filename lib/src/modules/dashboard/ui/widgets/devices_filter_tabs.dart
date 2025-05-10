import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';

class FilterTabsRow extends StatelessWidget {
  final int selectedTabIndex;
  final Function(int) onTabSelected;

  const FilterTabsRow({
    super.key,
    required this.selectedTabIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: ColorManager.grey300,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          _buildTab(context, S.of(context).consumption, 0),
          _buildTab(context, S.of(context).rooms, 1),
          _buildTab(context, S.of(context).priority, 2),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, String title, int index) {
    final isSelected = selectedTabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? ColorManager.primary : ColorManager.transparent,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? ColorManager.white : ColorManager.darkGrey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}