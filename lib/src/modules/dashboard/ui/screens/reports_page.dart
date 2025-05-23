import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/report.dart';
import 'package:tarsheed/src/modules/dashboard/ui/widgets/ai-sugg_card.dart';
import 'package:tarsheed/src/modules/dashboard/ui/widgets/report_large_card.dart';
import 'package:tarsheed/src/modules/dashboard/ui/widgets/usage_card.dart';

import '../../../../core/error/exception_manager.dart';
import '../../../../core/widgets/appbar.dart';
import '../../bloc/dashboard_bloc.dart';
import '../widgets/chart.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomAppBar(text: S.of(context).reports, withBackButton: false),
          _ReportsContent(),
        ],
      ),
    );
  }
}

class _ReportsContent extends StatefulWidget {
  @override
  _ReportsContentState createState() => _ReportsContentState();
}

class _ReportsContentState extends State<_ReportsContent> {
  final List<String> _periods = [S.current.month];
  int _selectedPeriodIndex = 0;
  String _currentPeriod = "";

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    final now = DateTime.now();
    _currentPeriod = "04-${now.year}";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData();
    });
  }

  void _fetchInitialData() {
    final bloc = context.read<DashboardBloc>();
    bloc.add(GetUsageReportEvent()); // period: "04-${DateTime.now().year}"
    bloc.add(GetAISuggestionsEvent());
  }

  void _onPeriodChanged(int index) {
    setState(() {
      _selectedPeriodIndex = index;
    });
    final now = DateTime.now();
    _currentPeriod = "${now.month}-${now.year}";
    context
        .read<DashboardBloc>()
        .add(GetUsageReportEvent(period: _currentPeriod));
  }

  void _onMonthChanged(String period) {
    setState(() {
      _currentPeriod = period;
    });
    context.read<DashboardBloc>().add(GetUsageReportEvent(period: period));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          spacing: 20.h,
          children: [
            _ChartSection(),
            _ReportContentSection(),
            _AISuggestionsSection()
          ],
        ),
      ),
    );
  }
}

class _ReportContentSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) =>
          current is GetUsageReportSuccess ||
          current is GetUsageReportError ||
          current is GetUsageReportLoading,
      builder: (context, state) {
        if (state is GetUsageReportLoading) {
          return CustomLoadingWidget();
        }
        if (state is GetUsageReportError) {
          return Center(
            child: CustomErrorWidget(
              message: ExceptionManager.getMessage(state.exception),
            ),
          );
        }
        if (state is GetUsageReportSuccess) {
          return _buildReportContent(context, state.report);
        }
        return Container();
      },
    );
  }

  Widget _buildReportContent(BuildContext context, Report report) {
    return SingleChildScrollView(
      child: Column(
        spacing: 10.h,
        children: [
          BuildInfoCard(
            icon: Icons.show_chart,
            title: S.of(context).avgUsage,
            value: '${report.averageConsumption.toStringAsFixed(2)} kWh',
            percentage: '${report.savingsPercentage}%',
            isDecrease: report.savingsPercentage > 0,
            color: ColorManager.primary,
          ),
          BuildInfoCard(
            icon: Icons.attach_money,
            title: S.of(context).avgCost,
            value: '\$${report.averageCost.toStringAsFixed(2)}',
            percentage: '${report.savingsCostPercentage}%',
            isDecrease: report.savingsCostPercentage > 0,
            color: ColorManager.primary,
          ),
          _UsageForecastSection(
            lastMonthUsage: "${report.previousTotalConsumption}",
            nextMonthUsage: "${report.totalConsumption}",
          ),
          Text(
            "${S.of(context).lowTierSystemMessage} ${report.tier}",
            style: TextStyle(fontSize: 14.sp),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}

class _ChartSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) =>
          current is GetUsageReportSuccess ||
          current is GetUsageReportError ||
          current is GetUsageReportLoading,
      builder: (context, state) {
        if (state is GetUsageReportLoading) {
          return SizedBox(height: 270.h, child: CustomLoadingWidget());
        }
        if (state is GetUsageReportError) {
          return Center(
            child: CustomErrorWidget(
              message: ExceptionManager.getMessage(state.exception),
            ),
          );
        }
        if (DashboardBloc.get().report != null) {
          return UsageChartWidget(
            chartData: DashboardBloc.get().report!.consumptionIntervals,
          );
        }
        return Container();
      },
    );
  }
}

class _UsageForecastSection extends StatelessWidget {
  final String lastMonthUsage;
  final String nextMonthUsage;

  const _UsageForecastSection({
    required this.lastMonthUsage,
    required this.nextMonthUsage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        UsageCard(
          title: S.of(context).lastMonthUsage,
          value: '$lastMonthUsage kWh',
        ),
        SizedBox(width: 12.w),
        UsageCard(
          title: S.of(context).currentMonthUsage,
          value: '$nextMonthUsage kWh',
          subtitle: S.of(context).projectedBasedOnUsageHistory,
        ),
      ],
    );
  }
}

class _AISuggestionsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20.h,
      children: [
        Text(S.of(context).aiSuggestions,
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: ColorManager.black)),
        BlocBuilder<DashboardBloc, DashboardState>(
          buildWhen: (previous, current) =>
              current is GetAISuggestionsLoading ||
              current is GetAISuggestionsSuccess ||
              current is GetAISuggestionsError,
          builder: (context, state) {
            if (state is GetAISuggestionsLoading) {
              return SizedBox(height: 120.h, child: CustomLoadingWidget());
            }

            if (state is GetAISuggestionsError) {
              return SizedBox(
                height: 120.h,
                child: CustomErrorWidget(
                    message: ExceptionManager.getMessage(state.exception)),
              );
            }

            if (state is GetAISuggestionsSuccess) {
              return AISuggestionCard(suggestion: state.suggestion);
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
