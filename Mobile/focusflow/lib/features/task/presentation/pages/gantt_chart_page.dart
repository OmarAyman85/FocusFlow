import 'package:flutter/material.dart';
import 'package:focusflow/features/task/domain/entities/task_entity.dart';
import 'package:gantt_chart/gantt_chart.dart'; // Import GanttChart package

class GanttChartPage extends StatelessWidget {
  final List<TaskEntity> tasks;

  const GanttChartPage({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    // Convert tasks into Gantt chart format
    List<GanttAbsoluteEvent> ganttEvents =
        tasks.map((task) {
          return GanttAbsoluteEvent(
            // Start date of the task
            startDate: task.createdAt,
            // End date of the task (use due date or created date if not available)
            endDate: task.dueDate ?? task.createdAt,
            displayName: task.title, // Use the task title for the event name
          );
        }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Gantt Chart')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GanttChartView(
          maxDuration: const Duration(
            days: 30 * 2,
          ), // Optional, set to null for infinite horizontal scroll
          startDate: DateTime(2022, 6, 7), // Required start date for the chart
          dayWidth: 30, // Column width for each day
          eventHeight: 30, // Row height for events
          stickyAreaWidth: 200, // Sticky area width
          showStickyArea: true, // Show sticky area or not
          showDays: true, // Show days or not
          startOfTheWeek: WeekDay.sunday, // Custom start of the week
          weekEnds: const {WeekDay.friday, WeekDay.saturday}, // Custom weekends
          isExtraHoliday: (context, day) {
            // Define custom holiday logic for each day
            return DateUtils.isSameDay(DateTime(2022, 7, 1), day);
          },
          events: ganttEvents, // List of Gantt events
        ),
      ),
    );
  }
}
