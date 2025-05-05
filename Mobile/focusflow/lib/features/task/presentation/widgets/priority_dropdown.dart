import 'package:flutter/material.dart';

class PriorityDropdown extends StatelessWidget {
  final String currentPriority;
  final Function(String) onChanged;

  const PriorityDropdown({
    super.key,
    required this.currentPriority,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: currentPriority,
      decoration: const InputDecoration(labelText: 'Priority'),
      onChanged: (value) => onChanged(value!),
      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
      items: const [
        DropdownMenuItem(value: 'Low', child: Text('Low')),
        DropdownMenuItem(value: 'Medium', child: Text('Medium')),
        DropdownMenuItem(value: 'High', child: Text('High')),
      ],
    );
  }
}
