import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      child: BottomNavigationBar(
        onTap: (val) {
          setState(() {
            selectIndex = val;
          });
        },
        currentIndex: selectIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: ColorManager.white,
        unselectedItemColor: ColorManager.grey300,
        selectedItemColor: ColorManager.primary,
        elevation: 10,
        iconSize: 24.sp,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
      ),
    );
  }
}
