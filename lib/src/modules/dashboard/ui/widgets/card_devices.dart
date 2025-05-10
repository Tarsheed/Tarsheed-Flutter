import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/category.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import '../../data/models/device.dart';

class DeviceCard extends StatelessWidget {
  final Device device;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final ValueChanged<bool> onToggle;

  const DeviceCard({
    super.key,
    required this.device,
    this.onEdit,
    this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = device.state ? ColorManager.white : ColorManager.black;
    final dashboardBloc = context.read<DashboardBloc>();

    final deviceCategory = dashboardBloc.categories.firstWhere(
            (category) => category.id == device.categoryId,
        orElse: () => DeviceCategory.empty);

    return SizedBox(
      height: 160.h,
      width: 180.w,
      child: GestureDetector(
        onLongPress: onDelete,
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: device.state ? ColorManager.primary : ColorManager.grey200,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: ColorManager.black12,
                blurRadius: 6.r,
                offset: Offset(0, 3.h),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildCategoryIcon(deviceCategory, textColor),
                      const Spacer(),
                      Switch(
                        value: device.state,
                        onChanged: onToggle,
                        activeColor: ColorManager.white,
                        inactiveThumbColor: ColorManager.grey,
                      ),
                    ],
                  ),
                  Text(
                    device.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    device.description,
                    style: TextStyle(
                      color: textColor.withOpacity(0.8),
                      fontSize: 12.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.bolt,
                        size: 16.sp,
                        color: textColor.withOpacity(0.9),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${device.consumption.toStringAsFixed(1)} ${S.of(context).kwh}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: textColor.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.priority_high,
                        size: 16.sp,
                        color: textColor.withOpacity(0.9),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _getPriorityText(device.priority, context),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: textColor.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                bottom: 4.h,
                right: 4.w,
                child: GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: device.state ? ColorManager.white : ColorManager.grey300,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit,
                      size: 16.sp,
                      color: textColor,
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

  Widget _buildCategoryIcon(DeviceCategory category, Color color) {
    if (category.iconUrl.startsWith('http')) {
      return BlocBuilder<DashboardBloc, DashboardState>(
        buildWhen: (current, previous) => current is DeviceCategoryState,
        builder: (context, state) {
          return state is GetDevicesLoading
              ? SizedBox()
              : Image.network(
            category.iconUrl,
            height: 40.h,
            width: 40.w,
            color: color,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.devices,
                size: 40.sp,
                color: color,
              );
            },
          );
        },
      );
    } else {
      return Image.asset(
        category.iconUrl,
        height: 40.h,
        width: 40.w,
        color: color,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            _getCategoryIcon(category.id),
            size: 40.sp,
            color: color,
          );
        },
      );
    }
  }

  String _getPriorityText(int priority, BuildContext context) {
    if (priority <= 3) {
      return S.of(context).priorityLow;
    } else if (priority <= 7) {
      return S.of(context).priorityMedium;
    } else {
      return S.of(context).priorityHigh;
    }
  }

  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'light':
      case 'lighting':
        return Icons.lightbulb;
      case 'ac':
      case 'air_conditioner':
        return Icons.ac_unit;
      case 'tv':
      case 'television':
        return Icons.tv;
      case 'refrigerator':
      case 'fridge':
        return Icons.kitchen;
      case 'fan':
        return Icons.air;
      case 'heater':
      case 'water_heater':
        return Icons.hot_tub;
      case 'washing_machine':
        return Icons.local_laundry_service;
      case 'vacuum':
      case 'vacuum_cleaner':
        return Icons.cleaning_services;
      default:
        return Icons.electrical_services;
    }
  }
}

extension DeviceExtension on Device {
  String get categoryId => this.categoryId ?? 'default';
}