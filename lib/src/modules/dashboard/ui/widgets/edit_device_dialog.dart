import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../data/models/device.dart';

class EditDeviceDialog extends StatefulWidget {
  final Device device;
  const EditDeviceDialog({super.key, required this.device});

  @override
  State<EditDeviceDialog> createState() => _EditDeviceDialogState();
}

class _EditDeviceDialogState extends State<EditDeviceDialog> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController pinNumberController;
  bool isModified = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.device.name);
    descriptionController = TextEditingController(text: widget.device.description);
    pinNumberController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardBloc, DashboardState>(
      listenWhen: (previous, current) =>
      current is EditDeviceSuccess || current is EditDeviceError,
      listener: (context, state) {
        if (state is EditDeviceSuccess) {
          Navigator.of(context).pop();
        } else if (state is EditDeviceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).failedToEditDevice)),
          );
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(S.of(context).editDeviceTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(S.of(context).deviceName, nameController),
              SizedBox(height: 10.h),
              _buildTextField(S.of(context).description, descriptionController),
              SizedBox(height: 10.h),
              _buildTextField(S.of(context).pinNumber, pinNumberController),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: isModified && !isLoading ? _onSavePressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isModified ? ColorManager.primary : ColorManager.grey,
            ),
            child: isLoading
                ? SizedBox(
              width: 20.w,
              height: 20.h,
              child: CircularProgressIndicator(
                color: ColorManager.white,
                strokeWidth: 2.w,
              ),
            )
                : Text(S.of(context).save),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      onChanged: (_) => setState(() => isModified = true),
    );
  }

  void _onSavePressed() {
    setState(() => isLoading = true);
    context.read<DashboardBloc>().add(
      EditDeviceEvent(
        id: widget.device.id,
        name: nameController.text,
        description: descriptionController.text,
        pinNumber: pinNumberController.text,
      ),
    );
  }
}