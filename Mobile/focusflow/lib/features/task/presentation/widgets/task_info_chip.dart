import 'package:flutter/material.dart';

class TaskInfoChip extends StatelessWidget {
  final String label;
  final Color color;

  const TaskInfoChip({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
      backgroundColor: color,
    );
  }
}
