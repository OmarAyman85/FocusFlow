import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:focusflow/core/theme/app_pallete.dart';

class DueDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onPickDate;

  const DueDatePicker({
    super.key,
    required this.selectedDate,
    required this.onPickDate,
  });

  Future<void> _pickDueDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) onPickDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Due Date:'),
        const SizedBox(width: 12),
        Text(
          selectedDate == null
              ? 'None'
              : DateFormat('yyyy-MM-dd').format(selectedDate!),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => _pickDueDate(context),
          style: TextButton.styleFrom(foregroundColor: AppPallete.gradient1),
          child: const Text('Pick Date'),
        ),
      ],
    );
  }
}
