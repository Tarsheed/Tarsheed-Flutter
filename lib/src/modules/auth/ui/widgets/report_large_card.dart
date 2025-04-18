import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';

class BuildInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String percentage;
  final bool isDecrease;
  final Color color;

  const BuildInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.percentage,
    required this.isDecrease,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorManager.primary,
                // Using the provided color parameter
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: ColorManager.darkGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      color: ColorManager.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    isDecrease
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                    color: isDecrease ? ColorManager.primary : ColorManager.red,
                    // Using the provided color for decrease
                    size: 20,
                    weight: 800,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    percentage,
                    style: TextStyle(
                      color:
                          isDecrease ? ColorManager.primary : ColorManager.red,
                      fontWeight: FontWeight.w700,
                      fontSize: 24, // Reduced font size to better fit
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
