import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/core/widgets/appbar.dart';
import 'package:tarsheed/src/core/widgets/bottom_navigator_bar.dart';
import 'package:tarsheed/src/core/widgets/rectangle_background.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/sensor_category.dart';
import 'package:tarsheed/src/modules/dashboard/ui/widgets/report_large_card.dart';
import 'package:tarsheed/src/modules/dashboard/ui/screens/add_sensor_form_page.dart';

class SensorsScreen extends StatelessWidget {
  const SensorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      extendBody: true,
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(child: BackGroundRectangle()),
            Column(
              children: [
                CustomAppBar(text: S.of(context).sensors),
                SizedBox(height: 10.h),
                SizedBox(height: 10.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: BlocBuilder(
                      buildWhen: (previous, current) => current is SensorState,
                      bloc: DashboardBloc.get()..add(GetSensorsEvent()),
                      builder: (context, state) {
                        if (state is GetSensorsLoadingState) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 100.h,
                              horizontal: 10.w,
                            ),
                            child: SizedBox(
                              height: 120.h,
                              child: const CustomLoadingWidget(),
                            ),
                          );
                        } else if (state is GetSensorsErrorState) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 100.h,
                              horizontal: 10.w,
                            ),
                            child: SizedBox(
                              height: 120.h,
                              child: CustomErrorWidget(
                                message: ExceptionManager.getMessage(state.exception),
                              ),
                            ),
                          );
                        } else if ((state is GetSensorsSuccessState && state.sensors.isEmpty) ||
                            DashboardBloc.get().sensors.isEmpty) {
                          return const NoDataWidget();
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: DashboardBloc.get().sensors.length,
                            itemBuilder: (context, index) {
                              final sensor = DashboardBloc.get().sensors[index];
                              final category = SensorCategory.values.firstWhere(
                                    (e) => e.id == sensor.categoryId,
                                orElse: () => SensorCategory.temperature,
                              );
                              return BuildInfoCard(
                                iconWidget: Image.asset(
                                  category.imagePath,
                                  width: 30.w,
                                  height: 30.h,
                                  fit: BoxFit.cover,
                                ),
                                title: "${category.name}: ${sensor.name}",
                                value: sensor.description,
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorManager.primary,
        onPressed: () {
          context.push(const AddSensorFormPage());
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNavigator(),
    );
  }
}