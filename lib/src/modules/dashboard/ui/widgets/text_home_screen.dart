import 'package:flutter/material.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';

class CustomTextWidget extends StatelessWidget {
  final String label;
  final double size;

  const CustomTextWidget({
    Key? key,
    required this.label,
    required this.size,
  }) : super(key: key);

  TextStyle _getTextStyle({double? fontSize}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: ColorManager.black,
      shadows: [
        Shadow(
          color: ColorManager.black.withOpacity(0.5),

        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: _getTextStyle(fontSize: size),
    );
  }
}
