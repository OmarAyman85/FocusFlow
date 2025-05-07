import 'package:flutter/material.dart';
import 'package:focusflow/core/widgets/main_app_bar_widget.dart';
import 'package:focusflow/features/task/domain/entities/task_entity.dart';
import 'package:gantt_chart/gantt_chart.dart';

class GanttChartPage extends StatelessWidget {
  final List<TaskEntity> tasks;

  const GanttChartPage({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    List<GanttAbsoluteEvent> ganttEvents =
        tasks.map((task) {
          return GanttAbsoluteEvent(
            startDate: task.createdAt,
            endDate:
                task.dueDate ?? task.createdAt.add(const Duration(days: 90)),
            displayName: task.title,
          );
        }).toList();

    final chartStartDate =
        tasks.isNotEmpty
            ? tasks
                .map((t) => t.createdAt)
                .reduce((a, b) => a.isBefore(b) ? a : b)
            : DateTime.now();

    return Scaffold(
      appBar: MainAppBar(title: 'Tasks'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GanttChartView(
          startDate: chartStartDate,
          maxDuration: const Duration(days: 90),
          dayWidth: 30,
          eventHeight: 30,
          stickyAreaWidth: 200,
          showStickyArea: true,
          showDays: true,
          startOfTheWeek: WeekDay.sunday,
          weekEnds: const {WeekDay.friday, WeekDay.saturday},
          isExtraHoliday:
              (context, day) => DateUtils.isSameDay(DateTime(2022, 7, 1), day),
          events: ganttEvents,
        ),
      ),
    );
  }
}
