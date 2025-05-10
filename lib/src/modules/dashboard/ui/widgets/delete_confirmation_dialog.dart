import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import '../../bloc/dashboard_bloc.dart';

class DeleteDeviceDialog extends StatelessWidget {
  final String deviceId;

  const DeleteDeviceDialog({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).deleteDeviceTitle),
      content: Text(S.of(context).deleteDeviceConfirmation),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(S.of(context).cancel),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<DashboardBloc>().add(DeleteDeviceEvent(deviceId));
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: ColorManager.red),
          child: Text(S.of(context).yesDelete),
        ),
      ],
    );
  }
}