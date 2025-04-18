import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/modules/auth/ui/widgets/report_large_card.dart';
import 'package:tarsheed/src/modules/auth/ui/widgets/usage_card.dart';
import '../../../../core/error/exception_manager.dart';
import '../../../dashboard/bloc/dashboard_bloc.dart';
import '../widgets/appbar.dart';
import '../widgets/bottomNavigatorBar.dart';
import '../widgets/chart.dart';
import '../widgets/large_button.dart';
import '../widgets/month_navigaion.dart';
import '../widgets/select_time_period.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final List<String> _periods = [
    S.current.today,
    S.current.week,
    S.current.month,
    S.current.years,
  ];
  int _selectedPeriodIndex = 3;

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(GetUsageReportEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavigator(currentIndex: 1),
      appBar: CustomAppBar(text: S.of(context).reports),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is GetUsageReportLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetUsageReportError) {
            ExceptionManager.showMessage(state.exception);
            return Center(child: Text(S.of(context).errorLoadingReportData));
          } else if (state is GetUsageReportSuccess) {
            final report = state.report;

            final avgUsage = (report.period != null && report.period != 0)
                ? (report.totalConsumption / report.period!).toStringAsFixed(2)
                : report.totalConsumption.toStringAsFixed(2);

            final avgCost = (report.totalConsumption * 0.85).toStringAsFixed(2);
            final lastMonthUsage =
                report.previousConsumption.toStringAsFixed(2);
            final nextMonthUsage =
                (report.totalConsumption * 1.05).toStringAsFixed(2);
            final savingsPercentage =
                report.savingsPercentage.toStringAsFixed(0);

            // dynamic decrease logic
            final isUsageDecreased =
                report.totalConsumption < report.previousConsumption;
            final isCostDecreased = (report.totalConsumption * 0.85) <
                (report.previousConsumption * 0.85);

            // optional: calculate cost savings percentage
            final previousCost = report.previousConsumption * 0.85;
            final currentCost = report.totalConsumption * 0.85;
            final costSavingsPercentage = previousCost == 0
                ? '0'
                : (((previousCost - currentCost) / previousCost) * 100)
                    .toStringAsFixed(0);

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  children: [
                    PeriodFilter(
                      periods: _periods,
                      initialSelectedIndex: _selectedPeriodIndex,
                      onPeriodChanged: (int index) {
                        setState(() {
                          _selectedPeriodIndex = index;
                        });
                        context
                            .read<DashboardBloc>()
                            .add(GetUsageReportEvent(period: index));
                      },
                    ),
                    UsageChartWidget(),
                    MonthNavigator(),
                    BuildInfoCard(
                      icon: Icons.show_chart,
                      title: S.of(context).avgUsage,
                      value: '$avgUsage kWh',
                      percentage: '$savingsPercentage%',
                      isDecrease: isUsageDecreased,
                      color: ColorManager.primary,
                    ),
                    SizedBox(height: 10.h),
                    BuildInfoCard(
                      icon: Icons.attach_money,
                      title: S.of(context).avgCost,
                      value: '\$$avgCost',
                      percentage: '$costSavingsPercentage%',
                      isDecrease: isCostDecreased,
                      color: ColorManager.primary,
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        UsageCard(
                          title: S.of(context).lastMonthUsage,
                          value: '$lastMonthUsage kWh',
                        ),
                        SizedBox(width: 12.w),
                        UsageCard(
                          title: S.of(context).nextMonthUsage,
                          value: '$nextMonthUsage kWh',
                          subtitle: S.of(context).projectedBasedOnUsageHistory,
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      S.of(context).lowTierSystemMessage,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
