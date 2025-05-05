import 'package:flutter/material.dart';

class TaskColorUtils {
  static Color priorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red.shade300;
      case 'Medium':
        return Colors.orange.shade300;
      case 'Low':
        return Colors.green.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  static Color statusColor(String status) {
    switch (status) {
      case 'To Do':
        return Colors.blue.shade100;
      case 'In Progress':
        return Colors.orange.shade100;
      case 'Completed':
        return Colors.green.shade100;
      case 'Blocked':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }
}
