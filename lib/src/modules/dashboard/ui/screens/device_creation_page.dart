import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/utils/image_manager.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/core/widgets/large_button.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../data/models/device_creation_form.dart';

enum SensorCategory {
  temperature,
  current,
  motion,
  vibration,
}

extension SensorImagePath on SensorCategory {
  String get imagePath {
    switch (this) {
      case SensorCategory.temperature:
        return AssetsManager.temperatureSensor;
      case SensorCategory.current:
        return AssetsManager.currentSensor;
      case SensorCategory.motion:
        return AssetsManager.motionSensor;
      case SensorCategory.vibration:
        return AssetsManager.vibrationSensor;
    }
  }
}

extension SensorData on SensorCategory {
  String localizedName(BuildContext context) {
    switch (this) {
      case SensorCategory.temperature:
        return S.of(context).temperatureSensor;
      case SensorCategory.current:
        return S.of(context).currentSensor;
      case SensorCategory.motion:
        return S.of(context).motionSensor;
      case SensorCategory.vibration:
        return S.of(context).vibrationSensor;
    }
  }

  String get id {
    switch (this) {
      case SensorCategory.temperature:
        return "6817b4b7f927a0b34e0756d7";
      case SensorCategory.current:
        return "6817b5bda500e527dbafb536";
      case SensorCategory.motion:
        return "6817b5bda500e527dbafb536";
      case SensorCategory.vibration:
        return "6817b5e3dc386af5382343f3";
    }
  }
}

class DeviceCreationPage extends StatefulWidget {
  @override
  _DeviceCreationPageState createState() => _DeviceCreationPageState();
}

class _DeviceCreationPageState extends State<DeviceCreationPage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final pinNumberController = TextEditingController();
  final priorityController = TextEditingController();

  String? selectedRoomId;
  String? selectedCategoryId;
  SensorCategory? selectedSensorType;
  int? selectedPriority;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).addDevice),
        backgroundColor: ColorManager.primary,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: S.of(context).deviceName),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: S.of(context).description),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: pinNumberController,
                    decoration: InputDecoration(labelText: S.of(context).pinNumber),
                  ),
                  SizedBox(height: 12.h),
                  BlocBuilder<DashboardBloc, DashboardState>(
                    builder: (context, state) {
                      final rooms = context.read<DashboardBloc>().rooms;
                      return DropdownButtonFormField<String>(
                        value: selectedRoomId,
                        hint: Text(S.of(context).selectRoom),
                        items: rooms.map((room) {
                          return DropdownMenuItem<String>(
                            value: room.id,
                            child: Text(room.name),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => selectedRoomId = value),
                      );
                    },
                  ),
                  SizedBox(height: 12.h),
                  BlocBuilder<DashboardBloc, DashboardState>(
                    builder: (context, state) {
                      return DropdownButtonFormField<String>(
                        value: selectedCategoryId,
                        decoration: InputDecoration(
                          labelText: S.of(context).selectCategory,
                        ),
                        items: DashboardBloc.get().categories.map((category) {
                          return DropdownMenuItem(
                            value: category.id,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => selectedCategoryId = val),
                      );
                    },
                  ),
                  SizedBox(height: 12.h),
                  DropdownButtonFormField<SensorCategory>(
                    value: selectedSensorType,
                    decoration: InputDecoration(
                      labelText: S.of(context).selectSensor,
                    ),
                    items: SensorCategory.values.map((type) {
                      return DropdownMenuItem<SensorCategory>(
                        value: type,
                        child: Row(
                          children: [
                            Image.asset(
                              type.imagePath,
                              width: 30.w,
                              height: 30.h,
                            ),
                            SizedBox(width: 10.w),
                            Text(type.localizedName(context)),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => selectedSensorType = value),
                  ),
                  SizedBox(height: 12.h),
                  DropdownButtonFormField<int>(
                    value: selectedPriority,
                    decoration: InputDecoration(
                      labelText: S.of(context).devicePriority,
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.warning, color: ColorManager.red),
                            SizedBox(width: 8.w),
                            Text(
                              S.of(context).priority1,
                              style: TextStyle(color: ColorManager.red),
                            ),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 2,
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: ColorManager.orange),
                            SizedBox(width: 8.w),
                            Text(
                              S.of(context).priority2,
                              style: TextStyle(color: ColorManager.orange),
                            ),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 3,
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: ColorManager.primary),
                            SizedBox(width: 8.w),
                            Text(
                              S.of(context).priority3,
                              style: TextStyle(color: ColorManager.primary),
                            ),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 4,
                        child: Row(
                          children: [
                            Icon(Icons.low_priority, color: ColorManager.grey),
                            SizedBox(width: 8.w),
                            Text(
                              S.of(context).priority4,
                              style: TextStyle(color: ColorManager.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedPriority = value;
                      });
                    },
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: BlocConsumer<DashboardBloc, DashboardState>(
                listener: (context, state) {
                  if (state is AddDeviceSuccess) {
                    Fluttertoast.showToast(msg: S.of(context).deviceAddedSuccessfully);
                    context.pop();
                  }
                },
                buildWhen: (current, previous) =>
                current is DeviceState ||
                    current is AddDeviceLoading ||
                    current is AddDeviceSuccess ||
                    current is AddDeviceError,
                builder: (context, state) {
                  return DefaultButton(
                    title: S.of(context).save,
                    isLoading: state is AddDeviceLoading,
                    onPressed: () {
                      if (_validateInputs()) {
                        final form = DeviceCreationForm(
                          name: nameController.text,
                          description: descriptionController.text,
                          pinNumber: pinNumberController.text,
                          roomId: selectedRoomId!,
                          categoryId: selectedCategoryId!,
                          priority: selectedPriority ?? 1,
                        );

                        context.read<DashboardBloc>().add(AddDeviceEvent(form));
                      }
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  bool _validateInputs() {
    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        pinNumberController.text.isEmpty ||
        selectedRoomId == null ||
        selectedCategoryId == null ||
        selectedPriority == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).pleaseFillAllFields),
        ),
      );
      return false;
    }
    return true;
  }
}
