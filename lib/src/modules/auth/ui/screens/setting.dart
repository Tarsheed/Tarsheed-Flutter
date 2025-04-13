import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/core/utils/localization_manager.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/login.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/show_dialog.dart';
import 'package:tarsheed/src/modules/settings/cubit/settings_cubit.dart';
import '../../../../core/error/exception_manager.dart';
import '../widgets/appbar.dart';
import '../widgets/bottomNavigatorBar.dart';
import '../widgets/container_with_switch.dart';
import 'energy_mode.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state is DeleteProfileSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Account deleted successfully")),
          );
          context.push(LoginPage());
        } else if (state is SettingsErrorState) {
          ExceptionManager.showMessage(state.exception);
        }
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigator(),
        appBar: CustomAppBar(text: S.of(context).settings),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: ListView(
            children: [
              BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) {
                  final cubit = SettingsCubit.getInstance;
                  final currentLang =
                      LocalizationManager.getCurrentLocale().languageCode;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.of(context).language,
                          style: TextStyle(
                              color: ColorManager.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10.h),
                      DropdownButtonFormField<String>(
                        value: currentLang,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10.w),
                        ),
                        items: [
                          DropdownMenuItem(value: 'en', child: Text('English')),
                          DropdownMenuItem(value: 'ar', child: Text('العربية')),
                        ],
                        onChanged: (value) {
                          if (value != null && value != currentLang) {
                            cubit.changeLanguage(value);
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 20.h),
              CustomContainer(
                text: S.of(context).backupSettings,
              ),
              CustomContainer(
                text: S.of(context).energyMode,
                icon: Icons.arrow_forward_ios,
                onpressed: () {
                  context.push(EnergyModePage());
                },
              ),
              CustomContainer(
                text: S.of(context).softwareUpdate,
              ),
              CustomContainer(
                text: S.of(context).helpAndSupport,
              ),
              SizedBox(height: 5.h),
              TextButton(
                onPressed: () {
                  showDeleteAccountDialog(context);
                },
                child: Center(
                  child: Text(
                    S.of(context).deleteMyAccount,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
