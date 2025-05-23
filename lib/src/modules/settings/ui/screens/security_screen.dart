import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import '../../../../core/widgets/appbar.dart';
import '../../../../core/widgets/bottom_navigator_bar.dart';
import '../../../../core/widgets/large_button.dart';
import '../widgets/container_with_switch.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const BottomNavigator(),
      appBar: CustomAppBar(text: S.of(context).security),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomContainer(
                text: S.of(context).faceId,
                size: 18.sp,
                height: 66.h,
                status: false,
              ),
              SizedBox(height: 12.h),
              CustomContainer(
                text: S.of(context).twoStepVerification,
                size: 18.sp,
                height: 66.h,
                status: true,
              ),
              SizedBox(height: 40.h),
              DefaultButton(
                title: S.of(context).save,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
