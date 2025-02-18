import 'dart:ui_web';

import 'package:flutter/cupertino.dart';

import '../../../../core/utils/image_manager.dart';
import 'circle_background.dart';

class BackGroundRectangle extends StatelessWidget {
  const BackGroundRectangle({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            bottom: 2,
            child: Image(image: AssetImage(AssetsManager.rectangle3))),
        Positioned(
            bottom: 2,
            child: Image(
              image: AssetImage(AssetsManager.rectangle4),
            )),
        CustomPaint(
          size: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height),
          painter: BackgroundCircle(),
        ),
      ],
    );
  }
}
