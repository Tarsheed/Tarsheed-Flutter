import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart'; // استيراد ملف الترجمة

import '../widgets/appbar.dart';
import '../widgets/bottomNavigatorBar.dart';
import '../widgets/container_with_switch.dart';
import '../widgets/large_button.dart';

class SecurityPage extends StatefulWidget {
  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavigator(currentIndex: -1),
      appBar: CustomAppBar(text: S.of(context).security),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomContainer(
                text: S.of(context).faceId,
                size: 18,
                height: 66.h,
                status: false,
              ),
              CustomContainer(
                text: S.of(context).twoStepVerification,
                size: 18,
                height: 66.h,
                status: true,
              ),
              SizedBox(height: 40.h),
              DefaultButton(
                title: S.of(context).save,
                width: double.infinity,
              )
            ],
          ),
        ),
      ),
    );
  }
}
