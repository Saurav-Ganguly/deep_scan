import 'package:flutter/material.dart';
import 'package:deep_scan/constants.dart';
import 'package:deep_scan/widgets/analyser_widgets/circular_progess_widget.dart';

class ChartCard extends StatelessWidget {
  const ChartCard({
    super.key,
    required this.percentage,
    required this.size,
    required this.color,
    required this.label,
    required this.name,
  });
  final int percentage;
  final double size;
  final Color color;
  final String label;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          CircularProgressWidget(
            percentage: percentage,
            size: size,
            color: color,
            text: label,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            '$name ↗️',
            style: const TextStyle(color: AppColors.myPurple),
          ),
        ],
      ),
    );
  }
}
