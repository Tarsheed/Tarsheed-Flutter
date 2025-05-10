
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/utils/image_manager.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/core/widgets/large_button.dart';
import 'package:tarsheed/src/core/widgets/text_field.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/sensor.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/sensor_category.dart';
import '../../bloc/dashboard_bloc.dart';

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
}

class AddSensorFormPage extends StatefulWidget {
  const AddSensorFormPage({super.key});

  @override
  State<AddSensorFormPage> createState() => _AddSensorFormPageState();
}

class _AddSensorFormPageState extends State<AddSensorFormPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController pinNumberController = TextEditingController();
  String? selectedRoomId;
  SensorCategory? selectedSensorType;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).addSensor),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return S.of(context).nameRequired;
                  }
                  return null;
                },
                controller: nameController,
                hintText: S.of(context).sensorName,
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: descriptionController,
                hintText: S.of(context).description,
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return S.of(context).pinNumberRequired;
                  }
                  return null;
                },
                controller: pinNumberController,
                hintText: S.of(context).pinNumber,
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
              DropdownButtonFormField<SensorCategory>(
                value: selectedSensorType,
                decoration: InputDecoration(
                  labelText: S.of(context).selectSensorType,
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
              SizedBox(height: 100.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: BlocConsumer<DashboardBloc, DashboardState>(
                  listener: (context, state) {
                    if (state is AddSensorLoadingState) {
                      showToast(S.of(context).sensorAdded);
                      context.pop();
                    }
                  },
                  buildWhen: (current, previous) =>
                  current is SensorState || current is AddDeviceLoading,
                  builder: (context, state) => DefaultButton(
                    title: S.of(context).save,
                    isLoading: state is AddDeviceLoading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        DashboardBloc.get().add(AddSensorEvent(Sensor(
                          name: nameController.text,
                          categoryId: selectedSensorType!.id,
                          pinNumber: pinNumberController.text,
                          roomId: selectedRoomId!,
                          description: descriptionController.text,
                          id: "",
                        )));
                      }
                    },
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
